using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class Dojam
    {
        public bool? IsLiked { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }
    }
}
