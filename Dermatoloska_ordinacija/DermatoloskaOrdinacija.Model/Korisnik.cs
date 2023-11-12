using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public partial class Korisnik
    {
        public int KorisnikId { get; set; }

        public string? Ime { get; set; }

        public string? Prezime { get; set; }

        public string? Username { get; set; }

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string? Adresa { get; set; }
        public byte[]? Slika { get; set; }

        public int? SpolId { get; set; }


        public TipKorisnika? TipKorisnika { get; set; } 
        public int? TipKorisnikaId { get; set; }
    }
}
