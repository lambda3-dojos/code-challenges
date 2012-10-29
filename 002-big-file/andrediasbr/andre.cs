using System.IO;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Collections.Generic;
using System;
using System.Text;

class Program {

   static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
           
            MD5 md5 = MD5.Create();
            HashSet<byte[]> hashSet = new HashSet<byte[]>();           
            string linha;
 
            string arquivoOriginal = "big-file.txt";
            string arquivoSemDuplicacao = "arquivoSemDuplicacao.txt";
            int tamanhoBuffer = 10 * 1024 * 1014;
 
            FileStream fsw = new FileStream(arquivoSemDuplicacao, FileMode.CreateNew);
            BufferedStream bsw = new BufferedStream(fsw, tamanhoBuffer);
            StreamWriter sw = new StreamWriter(bsw);
 
            using (FileStream fs = new FileStream(arquivoOriginal, FileMode.Open))
            {
                using (BufferedStream bs = new BufferedStream(fs, tamanhoBuffer))
                {
                    using (StreamReader sr = new StreamReader(bs))
                    {
                        while ((linha = sr.ReadLine()) != null)
                        {
                            byte[] hash = md5.ComputeHash(Encoding.ASCII.GetBytes(linha));
 
                            if (!hashSet.Contains(hash))
                            {
                                sw.WriteLine(linha);
                                hashSet.Add(hash);
                            }
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
