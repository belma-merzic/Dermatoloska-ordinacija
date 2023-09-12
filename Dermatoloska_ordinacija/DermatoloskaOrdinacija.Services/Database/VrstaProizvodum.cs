using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class VrstaProizvodum
{
    public int VrstaId { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<Proizvod> Proizvods { get; set; } = new List<Proizvod>();
}
