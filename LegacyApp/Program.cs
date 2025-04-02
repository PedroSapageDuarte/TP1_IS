using System;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LegacyApp
{
    //Classe que representa os dados de produção
    public class Pecas
    {
        public string CodigoPeca { get; set; }
        public DateTime DataProducao { get; set; }
        public TimeSpan HoraProducao { get; set; }
        public int TempoProducao { get; set; }
        public string CodigoResultado { get; set; }
        public DateTime? DataTeste { get; set; }
    }

    class Program
    {
        static async Task Main(string[] args)
        {
            Random random = new Random();

            //Códigos iniciais dos tipos de produtos
            string[] tiposProduto = { "aa", "ab", "ba", "bb" };

            while(true)
            {
                //Gerar os dados
                DateTime now = DateTime.Now;
                string dataProducaoStr = now.ToString("yyyy-MM-dd");
                string horaProducaoStr = now.ToString("HH:mm:ss");

                //Gerar código da peça aleatoriamente
                string tipo = tiposProduto[random.Next(tiposProduto.Length)];
                int numeroUnico = random.Next(0, 1000000); //0 até 999999
                string identificador = numeroUnico.ToString("D6"); //6 dígitos com zeros à esquerda
                string codigoPeca = tipo + identificador;

                //Gerar o tempo de produção aleatório (entre 10 e 50 segundos)
                int tempoProducao = random.Next(10, 51);

                //Gerar o código do resultado do teste aleatoriamente (entre 01 e 06)
                int resultadoTeste = random.Next(1, 7);
                string codigoResultado = resultadoTeste.ToString("D2");

                //Espera os segundos do tempo de produção da peça atual
                Thread.Sleep(tempoProducao * 1000);

                //Limpa a consola e mostra os dados da produção da nova peça depois do tempo de criação da mesma
                Console.Clear();
                Console.WriteLine(dataProducaoStr + " ; " + horaProducaoStr + " ; " + codigoPeca + " ; " + tempoProducao + " ; " + codigoResultado + ";");
            }
        }

    }
}
