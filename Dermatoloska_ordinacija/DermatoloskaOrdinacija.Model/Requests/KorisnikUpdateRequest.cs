using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class KorisnikUpdateRequest
    {

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string? Adresa { get; set; }
        public byte[]? Slika { get; set; }

    }
}
