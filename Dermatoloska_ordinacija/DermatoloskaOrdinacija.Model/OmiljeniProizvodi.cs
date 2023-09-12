using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class OmiljeniProizvodi
    {
        public int OmiljeniProizvodId { get; set; }

        public DateTime? DatumDodavanja { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }

    }
}
