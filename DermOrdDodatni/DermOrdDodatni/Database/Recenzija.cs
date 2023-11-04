using System;
using System.Collections.Generic;

namespace DermOrdDodatni.Database;


public partial class Recenzija
{
    public int RecenzijaId { get; set; }

    public string? Sadrzaj { get; set; }

    public DateTime? Datum { get; set; }

    public int? ProizvodId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Proizvod? Proizvod { get; set; }
}
