using System;
using System.Collections.Generic;

namespace DermOrdDodatni.Database;


public partial class Termin
{
    public int TerminId { get; set; }

    public DateTime? Datum { get; set; }

    public int? KorisnikIdDoktor { get; set; }

    public int? KorisnikIdPacijent { get; set; }

    public virtual Korisnik? KorisnikIdDoktorNavigation { get; set; }

    public virtual Korisnik? KorisnikIdPacijentNavigation { get; set; }
}
