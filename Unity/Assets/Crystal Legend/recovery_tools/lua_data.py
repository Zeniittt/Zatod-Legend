"""Read decompiled return-only Lua data tables without executing Lua."""
import re
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent / 'recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data'

class Reader:
    def __init__(self, source):
        pattern = r'\s+|--[^\n]*|"(?:\\.|[^"\\])*"|[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?|[A-Za-z_][A-Za-z_0-9]*|[{}\[\]=,;]'
        matches = list(re.finditer(pattern, source))
        if ''.join(m.group() for m in matches) != source:
            raise ValueError('Unsupported characters in Lua data')
        self.tokens = [m.group() for m in matches if not m.group().isspace() and not m.group().startswith('--')]
        self.position = 0

    def peek(self, distance=0):
        index = self.position + distance
        return self.tokens[index] if index < len(self.tokens) else None

    def take(self, expected=None):
        token = self.peek()
        self.position += 1
        if expected is not None and token != expected:
            raise ValueError(f'Expected {expected}; found {token}')
        return token

    def string(self, token):
        output = bytearray()
        index = 1
        escapes = {'a': 7, 'b': 8, 'f': 12, 'n': 10, 'r': 13, 't': 9, 'v': 11}
        while index < len(token) - 1:
            if token[index] != '\\':
                output.extend(token[index].encode())
                index += 1
                continue
            index += 1
            if token[index].isdigit():
                match = re.match(r'\d{1,3}', token[index:])
                output.append(int(match.group()))
                index += len(match.group())
            else:
                output.append(escapes.get(token[index], ord(token[index])))
                index += 1
        try:
            return output.decode('utf-8')
        except UnicodeDecodeError:
            return output.decode('gb18030')

    def value(self):
        token = self.peek()
        if token == '{':
            self.take()
            result = {}
            next_index = 1
            while self.peek() != '}':
                if self.peek() == '[':
                    self.take()
                    key = self.value()
                    self.take(']')
                    self.take('=')
                elif self.peek(1) == '=':
                    key = self.take()
                    self.take('=')
                else:
                    key = next_index
                    next_index += 1
                result[key] = self.value()
                if self.peek() in [',', ';']:
                    self.take()
                elif self.peek() != '}':
                    raise ValueError('Expected table separator')
            self.take('}')
            return result
        self.take()
        if token.startswith('"'):
            return self.string(token)
        if token in ('true', 'false', 'nil'):
            return {'true': True, 'false': False, 'nil': None}[token]
        if re.match(r'[-+]?\d|[-+]?\.', token):
            return float(token) if any(c in token for c in '.eE') else int(token)
        raise ValueError(f'Unexpected token {token}')

    def parse(self):
        self.take('return')
        result = self.value()
        if self.position != len(self.tokens):
            raise ValueError('Trailing Lua code in data file')
        return result

def read_table(name):
    return Reader((BASE / (name + '.lua')).read_text(encoding='utf-8')).parse()

def named_row(table, row):
    return {key: row.get(index) for key, index in table[2].items()}
