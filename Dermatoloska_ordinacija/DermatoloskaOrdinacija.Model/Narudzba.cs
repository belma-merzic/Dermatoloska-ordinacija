using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Narudzba
    {
        public int NarudzbaId { get; set; }

        public string? BrojNarudzbe { get; set; }

        public DateTime? Datum { get; set; }

        public string? Status { get; set; }

        public double? Iznos { get; set; }
        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
    }
}
