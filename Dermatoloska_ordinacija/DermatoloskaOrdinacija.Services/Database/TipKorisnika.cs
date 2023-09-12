using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class TipKorisnika
{
    public int TipKorisnikaId { get; set; }

    public string? Tip { get; set; }

    public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
}
