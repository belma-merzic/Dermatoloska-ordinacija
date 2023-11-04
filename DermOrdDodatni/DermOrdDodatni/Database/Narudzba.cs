using System;
using System.Collections.Generic;

namespace DermOrdDodatni.Database;

public partial class Narudzba
{
    public int NarudzbaId { get; set; }

    public string? BrojNarudzbe { get; set; }

    public DateTime? Datum { get; set; }

    public string? Status { get; set; }

    public int? KorisnikId { get; set; }

    public double? Iznos { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; } = new List<StavkaNarudzbe>();

    public virtual ICollection<Transakcija> Transakcijas { get; set; } = new List<Transakcija>();
}
