using System.IO;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Collections.Generic;
using System;
using System.Text;
using System.Threading.Tasks;

public class Program
{
    static void Main(string[] args)
    {
        string arquivoOriginal = args[0];
        string arquivoSemDuplicacao = args[1];
        int tamanhoBuffer = Int32.Parse(args[2]) * 1024 * 1014;

        Stopwatch stopWatch = new Stopwatch();
        stopWatch.Start();

        MD5 md5 = MD5.Create();
        HashSet<byte[]> hashSet = new HashSet<byte[]>();
        string linha;

        FileStream fsw = new FileStream(arquivoSemDuplicacao, FileMode.Create);
        BufferedStream bsw = new BufferedStream(fsw, tamanhoBuffer);
        StreamWriter sw = new StreamWriter(bsw);

        var taskFactory = new TaskFactory();

        Action<object> work = (o) =>
        {
            var line = o.ToString();
            var hash = md5.ComputeHash(Encoding.ASCII.GetBytes(line.ToString()));

            bool added;
            lock (hash)
            {
                added = hashSet.Add(hash);
            }
            if (added)
            {
                lock(sw)
                {
                    sw.WriteLine(line);
                }
            }

        };

        using (FileStream fs = new FileStream(arquivoOriginal, FileMode.Open))
        {
            using (BufferedStream bs = new BufferedStream(fs, tamanhoBuffer))
            {
                using (StreamReader sr = new StreamReader(bs))
                {
                    while ((linha = sr.ReadLine()) != null)
                    {
                        var task = taskFactory.StartNew(work, String.Copy(linha));
                    }
                }
            }
        }

        sw.Close();
        bsw.Close();
        fsw.Close();

        stopWatch.Stop();

        TimeSpan ts = stopWatch.Elapsed;
        string duracao = String.Format("{0:00}:{1:00}:{2:00}", ts.Hours, ts.Minutes, ts.Seconds);
        Console.WriteLine("Duração: " + duracao);
    }
}
