using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class Spol
{
    public int SpolId { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
}
