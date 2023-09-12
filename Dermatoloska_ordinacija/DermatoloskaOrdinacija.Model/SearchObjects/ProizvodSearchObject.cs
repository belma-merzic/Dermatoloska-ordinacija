using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.SearchObjects
{
    public class ProizvodSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; } 
        public string? Sifra { get; set; }
    }
}
