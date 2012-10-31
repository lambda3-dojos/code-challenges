using System;
using System.Collections.Generic;
using System.IO;
using System.IO.MemoryMappedFiles;
using System.Text;

namespace RemoveDuplication
{
    class Program
    {
        private const string FilePath = @big-file2.txt;

        static void Main()
        {
            var fileLength = new FileInfo(FilePath).Length;
            var currentLine = new Listbyte();
            var lines = new Liststring();

            using (var mmf = MemoryMappedFile.CreateFromFile(FilePath, FileMode.Open))
            {
                long offset = 0;
                long size = 0x40000000;

                while (size = fileLength)
                {
                    var view = mmf.CreateViewAccessor(offset, size);

                    for (long i = 0; i  size; i++)
                    {
                        var currentByte = view.ReadByte(i);

                        if (currentByte == 13)
                        {
                            currentLine.Reverse();
                            var currentLineAsArray = currentLine.ToArray();

                            var line = Encoding.UTF8.GetString(currentLineAsArray, 0, currentLineAsArray.Length);

                            if (!lines.Contains(line))
                                lines.Add(line);

                            currentLine.Clear();
                        }
                        else if (currentByte != 10)
                            currentLine.Insert(0, currentByte);
                    }

                    if (size == fileLength) break;

                    offset = size;
                    size = size  2  fileLength  fileLength  size  2;
                }
            }

            Console.WriteLine(lines.Count);

            Console.ReadKey();
        }
    }
}