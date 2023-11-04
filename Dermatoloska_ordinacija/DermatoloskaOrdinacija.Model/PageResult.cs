using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class PageResult<T>
    {
        public List<T> Result { get; set; } = null!;
        public int? Count { get; set; }
    }
}
