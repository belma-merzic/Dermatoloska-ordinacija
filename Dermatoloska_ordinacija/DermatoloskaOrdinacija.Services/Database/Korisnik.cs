using System;
using System.Collections.Generic;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public string? Username { get; set; }

    public string? Email { get; set; }

    public string? Telefon { get; set; }

    public string? Adresa { get; set; }
    public byte[]? Slika { get; set; }

    public string? LozinkaSalt { get; set; }

    public string? LozinkaHash { get; set; }

    public int? TipKorisnikaId { get; set; }

    public int? SpolId { get; set; }

    public virtual ICollection<Dojam> Dojams { get; set; } = new List<Dojam>();

    public virtual ICollection<Narudzba> Narudzbas { get; set; } = new List<Narudzba>();

    public virtual ICollection<Novost> Novosts { get; set; } = new List<Novost>();

    public virtual ICollection<OmiljeniProizvodi> OmiljeniProizvodis { get; set; } = new List<OmiljeniProizvodi>();

    public virtual ICollection<Recenzija> Recenzijas { get; set; } = new List<Recenzija>();

    public virtual Spol? Spol { get; set; }

    public virtual ICollection<Termin> TerminKorisnikIdDoktorNavigations { get; set; } = new List<Termin>();

    public virtual ICollection<Termin> TerminKorisnikIdPacijentNavigations { get; set; } = new List<Termin>();

    public virtual TipKorisnika? TipKorisnika { get; set; }

    public virtual ICollection<ZdravstveniKarton> ZdravstveniKartons { get; set; } = new List<ZdravstveniKarton>();
}
