using DermatoloskaOrdinacija.Controllers;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

[ApiController]
public class NarudzbaController : BaseCRUDController<Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
{
    public NarudzbaController(ILogger<BaseController<Narudzba, NarudzbaSearchObject>> logger, INarudzbaService service)
        : base(logger, service)
    {
    }
}