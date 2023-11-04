using System;
using System.Collections.Generic;

namespace DermOrdDodatni.Database;


public partial class Proizvod
{
    public int ProizvodId { get; set; }

    public string? Naziv { get; set; }

    public string? Sifra { get; set; }

    public decimal? Cijena { get; set; }

    public int? VrstaId { get; set; }

    public byte[]? Slika { get; set; }

    public string? StateMachine { get; set; }

    public virtual ICollection<Dojam> Dojams { get; set; } = new List<Dojam>();

    public virtual ICollection<OmiljeniProizvodi> OmiljeniProizvodis { get; set; } = new List<OmiljeniProizvodi>();

    public virtual ICollection<Recenzija> Recenzijas { get; set; } = new List<Recenzija>();

    public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; } = new List<StavkaNarudzbe>();

    public virtual VrstaProizvodum? Vrsta { get; set; }
}
