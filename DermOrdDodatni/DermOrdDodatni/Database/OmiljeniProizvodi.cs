using System;
using System.Collections.Generic;

namespace DermOrdDodatni.Database;


public partial class OmiljeniProizvodi
{
    public int OmiljeniProizvodId { get; set; }

    public DateTime? DatumDodavanja { get; set; }

    public int? ProizvodId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Proizvod? Proizvod { get; set; }
}
