using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Termin
    {
        public int TerminId { get; set; }

        public DateTime? Datum { get; set; }

        public int? KorisnikIdDoktor { get; set; }

        public int? KorisnikIdPacijent { get; set; }

        public virtual Korisnik? KorisnikIdDoktorNavigation { get; set; }

        public virtual Korisnik? KorisnikIdPacijentNavigation { get; set; }
    }
}
