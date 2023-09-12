using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class Dojam
{
    public int DojamId { get; set; }

    public bool? IsLiked { get; set; }

    public int? ProizvodId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Proizvod? Proizvod { get; set; }
}
