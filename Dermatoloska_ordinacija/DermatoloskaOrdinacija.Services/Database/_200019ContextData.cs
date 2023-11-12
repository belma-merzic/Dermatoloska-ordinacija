using DermatoloskaOrdinacija.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services.Database
{
    public partial class _200019Context
    {
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Spol>().HasData(
                new Spol()
                {
                    SpolId = 1,
                    Naziv = "M"
                },
                new Spol()
                {
                    SpolId = 2,
                    Naziv = "F"
                }
            );

            modelBuilder.Entity<TipKorisnika>().HasData(
                new TipKorisnika()
                {
                    TipKorisnikaId = 1,
                    Tip = "Pacijent"
                },
                new TipKorisnika()
                {
                    TipKorisnikaId = 2,
                    Tip = "Uposlenik"
                }
            );

            modelBuilder.Entity<VrstaProizvodum>().HasData(
                new VrstaProizvodum()
                {
                    VrstaId = 1,
                    Naziv = "Krema"
                },
                new VrstaProizvodum()
                {
                    VrstaId = 2,
                    Naziv = "Losion"
                }
            );

            modelBuilder.Entity<Korisnik>().HasData(
                new Korisnik()
                {
                    KorisnikId = 1,
                    Ime = "uposlenik",
                    Prezime = "uposlenik",
                    Username = "uposlenik",
                    Email = "uposlenik@gmail.com",
                    Telefon = "0612345678",
                    Adresa = "test",
                    LozinkaSalt = "cbRh4cvy1djCQHeiqTcggg==",
                    LozinkaHash = "vCJEzMq01/y2WfxocUBTkBMJ0i0=",
                    TipKorisnikaId = 2,
                    SpolId = 1
                },
                new Korisnik()
                {
                    KorisnikId = 2,
                    Ime = "pacijent",
                    Prezime = "pacijent",
                    Username = "pacijent",
                    Email = "pacijent@gmail.com",
                    Telefon = "0612345678",
                    Adresa = "test",
                    LozinkaSalt = "5baNMRJ0C3G1HK5A7lybxQ==",
                    LozinkaHash = "ZEGY1lcTmU1LHPvmEagd/1aXq6o=",
                    TipKorisnikaId = 1,
                    SpolId = 2
                }
            );

            modelBuilder.Entity<Proizvod>().HasData(
                new Proizvod()
                {
                    ProizvodId = 1,
                    Naziv = "Krema za akne",
                    Sifra = "555A",
                    Cijena = 50,
                    VrstaId = 1,
                    StateMachine = "draft"
                },
                new Proizvod()
                {
                    ProizvodId = 2,
                    Naziv = "Losion za lice",
                    Sifra = "555B",
                    Cijena = 40,
                    VrstaId = 2,
                    StateMachine = "draft"
                },
                new Proizvod()
                {
                    ProizvodId = 3,
                    Naziv = "Krema za lice",
                    Sifra = "555C",
                    Cijena = 40,
                    VrstaId = 1,
                    StateMachine = "draft"
                },
                new Proizvod()
                {
                    ProizvodId = 4,
                    Naziv = "Krema za rozaceu",
                    Sifra = "555D",
                    Cijena = 20,
                    VrstaId = 1,
                    StateMachine = "draft"
                },
                 new Proizvod()
                 {
                     ProizvodId = 5,
                     Naziv = "SPF krema",
                     Sifra = "555E",
                     Cijena = 30,
                     VrstaId = 1,
                     StateMachine = "draft"
                 },
                 new Proizvod()
                 {
                     ProizvodId = 6,
                     Naziv = "SPF losion",
                     Sifra = "555F",
                     Cijena = 35,
                     VrstaId = 2,
                     StateMachine = "draft"
                 },
                 new Proizvod()
                 {
                     ProizvodId = 7,
                     Naziv = "Krema za područje oko očiju",
                     Sifra = "555G",
                     Cijena = 15,
                     VrstaId = 1,
                     StateMachine = "draft"
                 },
                  new Proizvod()
                  {
                      ProizvodId = 8,
                      Naziv = "Losion za tijelo",
                      Sifra = "555H",
                      Cijena = 50,
                      VrstaId = 2,
                      StateMachine = "draft"
                  },
                  new Proizvod()
                  {
                      ProizvodId = 9,
                      Naziv = "Krema za tijelo",
                      Sifra = "555I",
                      Cijena = 40,
                      VrstaId = 1,
                      StateMachine = "draft"
                  },
                  new Proizvod()
                  {
                      ProizvodId = 10,
                      Naziv = "Krema za osip",
                      Sifra = "555J",
                      Cijena = 60,
                      VrstaId = 1,
                      StateMachine = "draft"
                  }
            );


            modelBuilder.Entity<Dojam>().HasData(
                new Dojam()
                {
                    DojamId = 1,
                    ProizvodId = 1,
                    IsLiked = true,
                    KorisnikId = 2
                }
            );

            modelBuilder.Entity<Recenzija>().HasData(
                new Recenzija()
                {
                    RecenzijaId = 1,
                    Sadrzaj = "Test recenzija",
                    Datum = DateTime.Now,
                    ProizvodId = 1,
                    KorisnikId = 2
                }
            );

            modelBuilder.Entity<ZdravstveniKarton>().HasData(
                new ZdravstveniKarton()
                {
                    ZdravstveniKartonId = 1,
                    Sadrzaj = "Test sadrzaj",
                    KorisnikId = 2
                }
            );

            modelBuilder.Entity<Termin>().HasData(
                new Termin()
                {
                    TerminId = 1,
                    Datum = DateTime.Now,
                    KorisnikIdDoktor = 1,
                    KorisnikIdPacijent = 2,
                }
            );

            modelBuilder.Entity<Novost>().HasData(
                new Novost()
                {
                    NovostId = 1,
                    Naslov = "Test naslov",
                    Sadrzaj = "Test sadrzaj",
                    DatumObjave = DateTime.Now,
                    KorisnikId = 1
                }
            );

            modelBuilder.Entity<OmiljeniProizvodi>().HasData(
                new OmiljeniProizvodi()
                {
                    OmiljeniProizvodId = 1,
                    DatumDodavanja = DateTime.Now,
                    ProizvodId = 1,
                    KorisnikId = 2
                }
            );

            modelBuilder.Entity<Narudzba>().HasData(
                new Narudzba()
                {
                    NarudzbaId = 1,
                    BrojNarudzbe = "#1",
                    Datum = DateTime.Now,
                    Status = "Pending",
                    KorisnikId = 2,
                    Iznos = 90
                },
                 new Narudzba()
                 {
                     NarudzbaId = 2,
                     BrojNarudzbe = "#2",
                     Datum = DateTime.Now,
                     Status = "Pending",
                     KorisnikId = 2,
                     Iznos = 60
                 }
            );

            modelBuilder.Entity<StavkaNarudzbe>().HasData(
                new StavkaNarudzbe()
                {
                    StavkaNarudzbeId = 1,
                    Kolicina = 1,
                    NarudzbaId = 1,
                    ProizvodId = 1
                },
                new StavkaNarudzbe()
                {
                    StavkaNarudzbeId = 2,
                    Kolicina = 1,
                    NarudzbaId = 1,
                    ProizvodId = 2
                },
                 new StavkaNarudzbe()
                 {
                     StavkaNarudzbeId = 3,
                     Kolicina = 1,
                     NarudzbaId = 2,
                     ProizvodId = 3
                 },
                  new StavkaNarudzbe()
                  {
                      StavkaNarudzbeId = 4,
                      Kolicina = 1,
                      NarudzbaId = 2,
                      ProizvodId = 4
                  }
            );

            modelBuilder.Entity<Transakcija>().HasData(
              new Transakcija()
              {
                  TranskcijaId = 1,
                  Iznos = 90,
                  NarudzbaId = 1,
                  StatusTransakcije = "approved",
                  TransId = "PAYID-MT3WXSA82J975902T912173T"
              }
          );
        }
    }
}
