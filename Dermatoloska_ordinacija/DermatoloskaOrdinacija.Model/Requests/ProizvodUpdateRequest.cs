using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class ProizvodUpdateRequest
    {

        public string? Naziv { get; set; }

        public decimal? Cijena { get; set; }

        public byte[]? Slika { get; set; }
        public string? Sifra { get; set; }
    }
}
