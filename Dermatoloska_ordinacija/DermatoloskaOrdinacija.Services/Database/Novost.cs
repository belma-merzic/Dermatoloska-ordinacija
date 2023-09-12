using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class Novost
{
    public int NovostId { get; set; }

    public string? Naslov { get; set; }

    public string? Sadrzaj { get; set; }

    public DateTime? DatumObjave { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
