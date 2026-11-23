import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.io.*;

/** Run the official unluac decompiler in one JVM, preserving per-file errors. */
public class BatchDecompile {
  public static void main(String[] args) throws Exception {
    Path input = Path.of(args[0]);
    Path output = Path.of(args[1]);
    Path report = Path.of(args[2]);
    List<Path> files;
    try (var walk = Files.walk(input)) {
      files = walk.filter(p -> p.toString().endsWith(".luac")).sorted().toList();
    }
    Files.createDirectories(report.getParent());
    int success = 0, failure = 0;
    try (var log = Files.newBufferedWriter(report, StandardCharsets.UTF_8)) {
      log.write("status\tpath\tdetail\n");
      for (int i = 0; i < files.size(); i++) {
        Path path = files.get(i);
        String rel = input.relativize(path).toString();
        Path target = output.resolve(rel.substring(0, rel.length() - 5) + ".lua");
        Files.createDirectories(target.getParent());
        Path partial = target.resolveSibling(target.getFileName() + ".partial");
        try {
          if (!Files.exists(target) || Files.size(target) == 0) {
            unluac.Main.decompile(path.toString(), partial.toString(), new unluac.Configuration());
            Files.move(partial, target, StandardCopyOption.REPLACE_EXISTING);
          }
          log.write("ok\t" + rel + "\t\n");
          success++;
        } catch (Throwable e) {
          Files.deleteIfExists(partial);
          log.write("error\t" + rel + "\t" + e.toString().replace('\n', ' ').replace('\t', ' ') + "\n");
          failure++;
        }
        if ((i + 1) % 250 == 0) {
          log.flush();
          System.out.println("Decompiled " + (i + 1) + "/" + files.size() + ": " + success + " ok, " + failure + " errors");
        }
      }
    }
    System.out.println("Decompile finished: " + success + " ok, " + failure + " errors");
  }
}
