using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class OmiljeniProizvodiUpsertRequest
    {
        public DateTime? DatumDodavanja { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }
    }
}
