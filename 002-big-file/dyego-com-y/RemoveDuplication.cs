using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace RemoveDuplication
{
    class Program
    {
        private const string FilePath = @"big-file-2.txt";
        private const string NewFilePath = @"unic-lines.txt";

        static Program()
        {
            if (File.Exists(NewFilePath))
                File.Delete(NewFilePath);
        }

        static void Main()
        {
            var stopwatch = Stopwatch.StartNew();

            var readLine = new HashSet<int>();

            using (var file = new StreamReader(FilePath, Encoding.UTF8, false, 1024))
            using (var sw = new StreamWriter(new BufferedStream(new FileStream(NewFilePath, FileMode.OpenOrCreate), 10 * 3072 * 3072)))
                while (!file.EndOfStream)
                {
                    var line = file.ReadLine();

                    if (readLine.Add(line.GetHashCode()))
                        sw.WriteLine(line);
                }

            stopwatch.Stop();

            Console.WriteLine("Time elapsed: " + stopwatch.Elapsed);

            Console.ReadKey();
        }
    }
}