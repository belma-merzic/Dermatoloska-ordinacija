using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Racun
    {
        public int RacunId { get; set; }

        public int? BrojRacuna { get; set; }

        public DateTime? Datum { get; set; }

        public decimal? Iznos { get; set; }

        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
    }
}
