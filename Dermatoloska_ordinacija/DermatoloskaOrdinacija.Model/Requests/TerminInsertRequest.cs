using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class TerminInsertRequest
    {
        public DateTime? Datum { get; set; }
        public int? KorisnikIdDoktor { get; set; }
        public int? KorisnikIdPacijent { get; set; }

    }
}
