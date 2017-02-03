using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace LoanScoring.Models
{
    public class LoanDetailModel
    {
        [Required(ErrorMessage ="Required")]
        public int loanId { get;set; }

        [Required(ErrorMessage ="Required")]
        [StringLength(50)]
        public string loanOriginatorName { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? loanAmnt { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? revolUtil { get; set; }

        [Required(ErrorMessage = "Required")]
        public double? intRate { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? mthsSinceLastRecod { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? annualIncJoint { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? dtiJoin { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? totalRecPrncp { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? allUtil { get; set; }
    }
}