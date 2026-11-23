using System;
using System.Linq;
using System.Text;
namespace Zatod.Heroes
{
    // Display names never replace the persisted character GUID.
    public static class GuestIdentity
    {
        public const int MaxNameLength=24;
        public static string Name(string value)
        {
            string name=string.Join(" ",(value??"").Normalize(NormalizationForm.FormC).Split((char[])null,StringSplitOptions.RemoveEmptyEntries));
            if(name.Length<1||name.Length>MaxNameLength)throw new ArgumentException("Enter a name of 1–24 characters.");
            if(name.Any(c=>!char.IsLetterOrDigit(c)&&c!=' '&&c!='_'&&c!='-'))throw new ArgumentException("Use letters, numbers, spaces, - or _ in your name.");
            return name;
        }
    }
}
