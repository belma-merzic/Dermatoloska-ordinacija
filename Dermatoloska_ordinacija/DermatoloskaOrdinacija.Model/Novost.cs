using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Novost
    {
        public int NovostId { get; set; }

        public string? Naslov { get; set; }

        public string? Sadrzaj { get; set; }

        public DateTime? DatumObjave { get; set; }

        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
    }
}
