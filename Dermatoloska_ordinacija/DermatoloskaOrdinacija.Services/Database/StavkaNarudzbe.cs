using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class StavkaNarudzbe
{
    public int StavkaNarudzbeId { get; set; }

    public int? Kolicina { get; set; }

    public int? NarudzbaId { get; set; }

    public int? ProizvodId { get; set; }

    public virtual Narudzba? Narudzba { get; set; }

    public virtual Proizvod? Proizvod { get; set; }
}
