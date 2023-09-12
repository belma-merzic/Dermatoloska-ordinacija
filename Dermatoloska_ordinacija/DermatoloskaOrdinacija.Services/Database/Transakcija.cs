using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class Transakcija
{
    public int TranskcijaId { get; set; }

    public int? NarudzbaId { get; set; }

    public double? Iznos { get; set; }

    public string? StatusTransakcije { get; set; }

    public string? TransId { get; set; }

    public virtual Narudzba? Narudzba { get; set; }
}
