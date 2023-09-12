using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Proizvod 
    {
        public int ProizvodID { get; set; }

        public string? Naziv { get; set; }

        public string? Sifra { get; set; }

        public decimal? Cijena { get; set; }

        public int? VrstaId { get; set; }

        public string? StateMachine { get; set; }
        public byte[]? Slika { get; set; }
    }
}
