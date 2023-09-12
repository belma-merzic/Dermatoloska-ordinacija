using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class ZdravstevniKartonInsertRequest
    {
        public string? Sadrzaj { get; set; }

        public int? KorisnikId { get; set; }
    }
}
