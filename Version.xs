#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/*-----------------12/18/2001 9:24AM----------------
 * $Revision: 3.0 $
 * --------------------------------------------------*/

typedef     SV *Universal_Version;

char * scan_version(char *version, SV *rv);
SV * new_version(SV *ver);
SV * vnumify(SV *sv, SV *vs);

char *
scan_version(pTHX_ char *s, SV *rv)
{
    char *d;
    int beta = 1;
    SV * sv = newSVrv(rv, "Universal::Version"); /* create an SV and upgrade the RV */

    d = s;
    if (*d == 'v')
        d++;
    if (isDIGIT(*d)) {
        while (isDIGIT(*d) || *d == '.')
            d++;
        if ( *d == '_' )
            beta = -1;
    }
    s = new_vstring(s,sv);      /* store the v-string in the object */
    SvREADONLY_off(sv);
    sv_setiv(sv,beta);
    SvIOK_off(sv);
    SvPOK_on(sv);
    return s;
}

SV *
new_version(SV *ver)
{
    SV *rv = NEWSV(92,5);
    char *version = (char *)SvPV_nolen(ver);
    version = scan_version(version,rv);
    return rv;
}

SV *
vnumify(SV *sv, SV *vs)
{
    U8* pv = (U8*)SvPVX(vs);
    STRLEN len = mg_length(vs);
    STRLEN retlen;
    UV digit = utf8_to_uvchr(pv,&retlen);
    sv_setpvf(sv,"%"UVf".",digit);
    for (pv += retlen, len -= retlen;
        len > 0;
        pv += retlen, len -= retlen)
    {
        digit = utf8_to_uvchr(pv,&retlen);
        sv_catpvf(sv,"%03"UVf,digit);
    }
    return sv;
}


MODULE = Universal::Version		PACKAGE = Universal::Version

PROTOTYPES: DISABLE
VERSIONCHECK: DISABLE

Universal_Version
new(class,version)
    char *class
    SV *version
PPCODE:
{
    PUSHs(new_version(version));
}

void
stringify (lobj,...)
    Universal_Version    lobj
OVERLOAD: \"\"
PPCODE:
{
    SV  *vs = NEWSV(92,5);
    sv_setpvf(vs,"%vd",lobj);
    PUSHs(vs);
}

void
numify (lobj,...)
    Universal_Version    lobj
OVERLOAD: 0+
PPCODE:
{
    SV  *vs = NEWSV(92,5);
    vnumify(vs,lobj);
    PUSHs(vs);
}

void
vcmp (lobj,...)
    Universal_Version 	 lobj
OVERLOAD: cmp <=>
PPCODE:
{
    SV	*rs;
    SV	*rvs;
    SV * robj = ST(1);
    IV	 swap = (IV)SvIV(ST(2));

    if ( ! sv_derived_from(robj, "Universal::Version") )
    {
	robj = new_version(robj);
    }
    rvs = SvRV(robj);

    if ( swap )
    {
        rs = newSViv(sv_cmp(rvs,lobj));
    }
    else
    {
        rs = newSViv(sv_cmp(lobj,rvs));
    }

    PUSHs(rs);
}

void
boolean(lobj,...)
    Universal_Version 	 lobj
OVERLOAD: bool
PPCODE:
{
    SV	*rs;
    rs = newSViv(sv_cmp(lobj,Nullsv));
    PUSHs(rs);
}

void
noop(lobj,...)
    Universal_Version 	 lobj
OVERLOAD: nomethod
CODE:
{
    croak("operation not supported with Universal::Version object");
}
