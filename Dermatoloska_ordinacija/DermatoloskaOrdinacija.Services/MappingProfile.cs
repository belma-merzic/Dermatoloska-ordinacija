using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using DermatoloskaOrdinacija.Model.Requests;

namespace DermatoloskaOrdinacija.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<Database.Korisnik, Model.Korisnik>();
            CreateMap<Model.Requests.KorisnikInsertRequest, Database.Korisnik>();
            CreateMap<Model.Requests.KorisnikUpdateRequest, Database.Korisnik>();

            CreateMap<Database.Proizvod, Model.Proizvod>();
            CreateMap<Model.Requests.ProizvodInsertRequest, Database.Proizvod>();
            CreateMap<Model.Requests.ProizvodUpdateRequest, Database.Proizvod>();



            CreateMap<Database.VrstaProizvodum, Model.VrstaProizvodum>();
            CreateMap<Database.TipKorisnika, Model.TipKorisnika>();

            CreateMap<Database.Novost, Model.Novost>();
            CreateMap<Model.Requests.NovostUpsertRequest, Database.Novost>();

            CreateMap<Database.ZdravstveniKarton, Model.ZdravstveniKarton>();
            CreateMap<Model.Requests.ZdravstevniKartonInsertRequest, Database.ZdravstveniKarton>();
            CreateMap<Model.Requests.ZdravstevniKartonUpdateRequest, Database.ZdravstveniKarton>();

            CreateMap<Database.Termin, Model.Termin>();
            CreateMap<Model.Requests.TerminInsertRequest, Database.Termin>();
            CreateMap<Model.Requests.TerminUpdateRequest, Database.Termin>();
            

            CreateMap<Database.Narudzba, Model.Narudzba>();
            CreateMap<Model.Requests.NarudzbaInsertRequest, Database.Narudzba>();
            CreateMap<Model.Requests.NarudzbaUpdateRequest, Database.Narudzba>();

            CreateMap<Database.OmiljeniProizvodi, Model.OmiljeniProizvodi>();
            CreateMap<Model.Requests.OmiljeniProizvodiUpsertRequest, Database.OmiljeniProizvodi>();

            CreateMap<Database.Dojam, Model.Dojam>().ReverseMap();

            CreateMap<Database.Recenzija, Model.Recenzija>();
            CreateMap<Model.Requests.RecenzijaInsertRequest, Database.Recenzija>();
            CreateMap<Model.Requests.RecenzijaUpdateRequest, Database.Recenzija>();


            CreateMap<Database.Transakcija, Model.Transakcija>();
            CreateMap<Model.Requests.TransakcijaUpsertRequest, Database.Transakcija>();


            CreateMap<Database.RecommendResult, Model.RecommendResult>();
            CreateMap<Model.Requests.RecommendResultUpsertRequest, Database.RecommendResult>();

            CreateMap<Database.StavkaNarudzbe, Model.StavkaNarudzbe>();
            CreateMap<Model.Requests.StavkaNarudzbeInsertRequest, Database.StavkaNarudzbe>();
            CreateMap<Model.Requests.StavkaNarudzbeUpdateRequest, Database.StavkaNarudzbe>();

        }
    }
}
