using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class ProizvodInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string? Naziv { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Sifra je obavezna")]
        public string? Sifra { get; set; }

        [Required]
        [Range(0,10000)]
        public decimal? Cijena { get; set; }

        public int? VrstaId { get; set; }

        public byte[]? Slika { get; set; }
    }
}
