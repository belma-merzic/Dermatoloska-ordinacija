using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class KorisnikInsertRequest
    {

        public string? Ime { get; set; }

        public string? Prezime { get; set; }

        public string? Username { get; set; }

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string? Adresa { get; set; }
        public int? SpolId { get; set; }


        [Compare("PasswordPotvrda", ErrorMessage = "Passwords do not match")]
        public string? Password { get; set; }

        [Compare("Password", ErrorMessage = "Passwords do not match")]
        public string? PasswordPotvrda { get; set; }
        public int? TipKorisnikaId { get; set; }

    }
}
