// Gehäuse für das WLAN-Thermometer "Mini"
//
// WTM_MaloriakV22.scad (OpenSCAD >= 2015.11.13)
//
// Version 2.2 - 13.2.2016
//
// Für FDM-Drucker angepasste Version des 
// originalen Gehäuses mit runden Ecken von Sisi
//
// Als Unterschied zur originalen Version habe ich den Deckel plan
// gemacht, damit er auf dem Drucktisch zu liegen kommmt und die 
// kleinen Gnubbel am Boden entfernt. Die Außenmasse von Deckel und Boden 
// sind daher gleich geblieben, ebenso die Innenmasse.
//
// Die Position der Anschlußlöcher im Deckel waren wohl etwas knapp,
// daher habe ich sie 0,7mm weiter Richtung Boden verschoben.
//
// Der Deckel und der Boden sind beide in dieser SCAD-Datei enthalten, sodass das einwandfreie
// Zusammenpassen der Teile anhand von Referenzpunkten sichergestellt ist.
//
// Ob der Boden oder der Deckel erzeugt wird und welche Anschlußlöcher erzeugt werden und
// ob Vorkehrungen gegen das Warpen generiert wird, lässt sich mittels Parameter einstellen.

// Dateien habe ich alle, zum Teil mehrfach, in PLA mit den Cura-Einstellungen
// 0.2 Schichtdicke, 20% Füllgrad, 0,8mm Wandstärke, 0,4mm unten/oben
// gedruckt und getestet. Mein Cura-Profil habe ich im Verzeichnis Cura-Profil abgelegt.
// Den Deckel im Slicer natürlich um 180 Grad drehen;-)
//
// Kontakt: Maloriak@Grillsportverein bzw. maloriak@gmail.com
//
// History:
// V2.0/20160130
// - plane Front, damit Deckel gut auf Druckbett aufliegt
// - etwas dünnere Front
// - rundere Ecken
// - schrägerer LCD-Ausschnitt
// - optional Anti-Warp-Support 
// V2.1/20160210
// - Anschlußlöcher werden jetzt analog zu V3 erzeugt
// V2.2/20160213
// - Verwendung von hochauflösenden Quelldateien
// - Front + LCD-Ausschnitt optimiert
// - Anschlüsse im Deckel 0.7mm weiter Richtung Boden

// Erzeuge Boden oder Deckel (nur eines auf "1" setzen!)
erzeuge_boden  = 1;  // =1 Boden erzeugen, =0 kein Boden erzeugen
erzeuge_deckel = 0;  // =1 Deckel erzeugen, =0 kein Deckel erzeugen

// Erzeuge die Anschlußvarianten (beliebig kombinierbar)
anschluss_mittig        = 1; // =1 Loch, =0 kein Loch
anschluss_links_rechts  = 0; // =1 Loch, =0 kein Loch

// Erzeuge Anti-Warp-Support
// Der Anti-Warp-Support ist optimiert auf möglichst kleine Verbindungsstellen 
// zum Druckstück (dadurch weniger Ausbessern nach dem Druck) und funktiniert 
// besser als der z.B. durch Cura automatisch erzeugte. Er wurde getestet mit 
// PLA. Es ist dann *kein* weiterer Warp-Schutz/Adhäsionsschutz nötig!
warp          = 1;  // =1 Anti-Warp-Schutz, =0 kein Anti-Warp-Schutz

// Verschiebung der Anschlußlöcher im Deckel Richtung Boden
delta_anschluss = 0.7; // Verbesserung von @DerZeitgeist

/////////////////////////////////////////////////////////////////////////////////
//////////////////////// Ab hier braucht nichts verändert werden. ///////////////
/////////////////////////////////////////////////////////////////////////////////

// Gehäusemasse
innenmass_boden_hoehe  = -17.5;
innenmass_deckel_hoehe = 15;
innenmass_breite       = 50;
innenmass_tiefe        = 50.5;

delta_tiefe = 0;
delta_breite = 0;

// Entwurfsmodus
entwurfsmodus  = 0;

// Qualität der Rundungen
quali = 150;

/////////////////////////////////////////////////////////////////////////////////
// Deckel erzeugen
if (erzeuge_deckel) {
    difference() {
        // Deckel geht in positive Z-Richtung
        union() {
            if (1) {
                color("blue")
                rotate([90,0,0])
                translate([0,0,0]) {
                    import("originalgehaeuse_20160209/Deckel_oben_Anschluss_mittig.stl");
                }
            }
            // Loch zumachen
            translate([-10,innenmass_tiefe - 1,0]) cube([20,3,12]);
            // Leider reicht das gerade Abschneiden des Deckels nicht um eine plane Fläche
            // zum Drucken zu bekommen. Wird das abgeschnitten, was nötig ist, bleibt an der
            // Stelle, wo das LCD anliegt eine viel zu dünne Wandstärke stehen.
            // Wird andererseits nicht genügend abgeschnitten, verbleiben Rundungen der Oberseite
            // zu den Seiten hin. Daher wird wie folgt vorgegangen: 
            // Zuerst wird insgesammt eine Plane Fläche hinzugefügt, aus der dann die
            // Auflagefläche der LCD und der LCD-Ausschnitt abgezogen wird und dann kann
            // insgesamt die Dicke reduziert werden. Auf diese Weise bleibt oberhalb 
            // der LCD ca. 1.5 mm Wandstärke stehen.
            if (entwurfsmodus == 0) {
                translate([0,0,0]) deckel_rahmen();
            }
        }
        if (entwurfsmodus == 0) deckel_abzug();
    }
    
    if (entwurfsmodus == 1) {
        deckel_abzug();
    }

    if (warp == 1) {
        color("red")
        rotate([90,0,0]) antiwarp_deckel();
    }
} // erzeuge_deckel

/////////////////////////////////////////////////////////////////////////////////
// Boden erzeugen
if (erzeuge_boden) {
    difference() {
        // Boden geht in negative Z-Richtung
        union() {
            if (1) {
                color("red")
                rotate([90,0,0])
                translate([0,0,0]) {
                    import("originalgehaeuse_20160209/Gehaeuse_Innenleben.stl");
                }
            }
        }
        if (entwurfsmodus == 0) boden_abzug();
    }
    
    if (entwurfsmodus == 1) {
        boden_abzug();
    }

    if (warp == 1) {
        color("green")
        rotate([90,0,0]) antiwarp_boden();
    }
} // erzeuge_boden

/////////////////////////////////////////////////////////////////////////

module deckel_rahmen() {
    l1 = 27;
    l2 = 30;
    q = 11.8;  // 14.1 = LCD
    
    a = 71.5;
    b = 54;
    difference() {
        if (1) {
            translate([0,0,q]) {
                translate([l1,l1,0]) scheibe();
                translate([-l1,,l1,0]) scheibe(); 
                translate([l1,-l1,0]) scheibe();
                translate([-l1,-l1,0]) scheibe();
                translate([l2,0,0]) quadrat();
                translate([-l2,0,0]) quadrat();
                translate([0,l2,0]) quadrat();
                translate([0,-l2,0]) quadrat();
            }
        }
        color("green")
        translate([-a/2 + 3,-b/2,innenmass_deckel_hoehe - 7.23]) cube([a,b,5]);
    }
}

module scheibe() {
    c1 = 60;
    s1 = 28;
    m1 = 4;
    intersection() {
        translate([-c1/2,-c1/2,0]) cube([c1,c1,m1]);
        sphere(s1, $fn=quali);
    }
}

module quadrat() {
    m1 = 4;
    c2 = 50;
    translate([-c2/2,-c2/2,0]) cube([c2,c2,m1]);
}

module deckel_abzug() {
    translate([0,0,0]) front_diff();
    
    // Anschlusslöcher
    k = 1.4 + delta_anschluss;
    if (anschluss_mittig == 1) {
        translate([0,innenmass_tiefe + 1,-k + (innenmass_deckel_hoehe / 2)]) 
        anschluss_diff();
    }

    if (anschluss_links_rechts == 1) {
        translate([-17,innenmass_tiefe + 1,-k + (innenmass_deckel_hoehe / 2)]) 
        anschluss_diff();
        translate([17,innenmass_tiefe + 1,-k + (innenmass_deckel_hoehe / 2)]) 
        anschluss_diff();
    }
   
   translate([0,0,0]) lcd_diff();
}

module boden_abzug() {
    bubbsje_teil_diff();
    mirror([0,1,0]) bubbsje_teil_diff();
    rotate([0,0,180]) {
        bubbsje_teil_diff();
        mirror([0,1,0]) bubbsje_teil_diff();
    }
}

module bubbsje_teil_diff() {
    m1 = 3;
    c2 = 12.8;
    translate([-innenmass_breite + 16, -innenmass_tiefe + 21.5, innenmass_boden_hoehe - 6])
    rotate([0,0,60])
    translate([-c2/2,-c2/2,0]) cube([c2,c2,m1]);
}

// bubbsje_diff();

/////////////////////////////////////////////////////////
// Front
module front_diff() {
    a = 110;
    b = 15.25;
    s = 0.6; // 0.6 ergibt 1.5mm Dicke wo LCD innen anliegt, // 2.1 LCD

    difference() {
        if (entwurfsmodus == 1) {
             deckel_rahmen();
        }
        translate([-innenmass_breite * 1.1,-innenmass_tiefe * 1.1,innenmass_deckel_hoehe - s]) 
        cube([innenmass_breite * 2.2,innenmass_tiefe * 2.2,10]);
    }
}


/////////////////////////////////////////////////////////
// LCD-Ausschnitt
module lcd_diff() {
    b = 58 / 2;
    h = 44 / 2;

    difference() {
        if (entwurfsmodus == 1) {
             translate([0,0,innenmass_deckel_hoehe]) cube([64,50,5], center = true);
        }
        union() {
            translate([-7.25,0,-innenmass_deckel_hoehe + 6.05]) 
            rotate([0,0,45])
            cylinder(h = 32, r1 = 0, r2 = 45, $fn=4);
            translate([7.25,0,-innenmass_deckel_hoehe + 6.05]) 
            rotate([0,0,45])
            cylinder(h = 32, r1 = 0, r2 = 45, $fn=4);
        }
    }
}

/////////////////////////////////////////////////////////
// Loch für einen Deckelanschluss
module anschluss_diff() {
    rotate([90,0,0]) {
        difference() {
            if (entwurfsmodus == 1) {
                translate([0,0,0]) cube([15,15,6], center = true);
            }
            union() {
            translate([0,0,-4]) cylinder(h = 8, r1 = 4, r2 = 4, $fn=quali);
            translate([0,0,-3.8]) cylinder(h = 4, r1 = 7, r2 = 6.5, $fn=6);
            }
        }
    
    }
}

/////////////////////////////////////////////////////////
// Anti-Warp (Deckel)
module antiwarp_deckel() {
  antiwarp_deckel_teil();
  translate([delta_breite - delta_tiefe,0,delta_breite - delta_tiefe ]) rotate([0,90,0]) antiwarp_deckel_teil();
  translate([0,0,0]) rotate([0,180,0]) antiwarp_deckel_teil();
  translate([delta_tiefe-delta_breite,0,delta_tiefe-delta_breite]) rotate([0,270,0]) antiwarp_deckel_teil();
    
  mirror([1,0,0]) antiwarp_deckel_teil();
  translate([delta_tiefe-delta_breite,0,delta_breite - delta_tiefe]) mirror([1,0,0]) rotate([0,90,0]) antiwarp_deckel_teil();
  mirror([1,0,0]) rotate([0,180,0]) antiwarp_deckel_teil();
  translate([delta_breite-delta_tiefe,0,delta_tiefe-delta_breite]) mirror([1,0,0]) rotate([0,270,0]) antiwarp_deckel_teil();
}

module antiwarp_deckel_teil() {
   d  = 0.3;
   q  = innenmass_deckel_hoehe - d - 0.6;
   p = 12;
   ab = innenmass_breite + 1;
   at = innenmass_tiefe + 1;
   b = 4;
  
   translate([ab, q, at - p - b]) cube([p + b, d, p + 3*b]);
   translate([ab + 2*b, q, -b]) cube([p - b, d, (innenmass_breite + innenmass_tiefe)/2 + b]);
}

/////////////////////////////////////////////////////////
// Anti-Warp (Boden)
module antiwarp_boden() {
  antiwarp_boden_teil();
  translate([delta_breite - delta_tiefe,0,delta_breite - delta_tiefe ]) rotate([0,90,0]) antiwarp_boden_teil();
  translate([0,0,0]) rotate([0,180,0]) antiwarp_boden_teil();
  translate([delta_tiefe-delta_breite,0,delta_tiefe-delta_breite]) rotate([0,270,0]) antiwarp_boden_teil();
    
  mirror([1,0,0]) antiwarp_boden_teil();
  translate([delta_tiefe-delta_breite,0,delta_breite - delta_tiefe]) mirror([1,0,0]) rotate([0,90,0]) antiwarp_boden_teil();
  mirror([1,0,0]) rotate([0,180,0]) antiwarp_boden_teil();
  translate([delta_breite-delta_tiefe,0,delta_tiefe-delta_breite]) mirror([1,0,0]) rotate([0,270,0]) antiwarp_boden_teil();
}

module antiwarp_boden_teil() {
   d  = 0.3;
   q  = innenmass_boden_hoehe - 2 - 1;
   p = 16;
   ab = innenmass_breite + 1 - 8;
   at = innenmass_tiefe + 1;
   b = 4;
  
   translate([ab, q, at - p - 2*b]) cube([p + b, d, p + 2*b]);
   translate([ab + 3*b, q, -b]) cube([p - 2*b, d, (innenmass_breite + innenmass_tiefe)/2 + b]);
}

/////////////////////////////////////////////////////////////////////////////////
// Referenzen

// Referenz: Übereinstimmung Platinenbefestigung Boden/Deckel
if (0) {
    /////////////////////////////////////////////////////////
    // Platinenbefestigung
    pl_x = 42.3;
    pl_y = 21.7;
    pl_z = -40;
    pl_v = 6;  // Versatz der linken Seite
    h = 80;
    b = 2.1;

    color("red") {
        translate([pl_x, pl_y, pl_z]) {
            rotate([0,0,90])
            translate([0,0,0]) cylinder(h = h, r1 = b, r2 = b, $fn=8);
        }
        translate([-pl_x + pl_v, pl_y, pl_z]) {
            rotate([0,0,90])
            translate([0,0,0]) cylinder(h = h, r1 = b, r2 = b, $fn=8);
        }
        translate([pl_x, -pl_y, pl_z]) {
            rotate([0,0,90])
            translate([0,0,0]) cylinder(h = h, r1 = b, r2 = b, $fn=8);
        }
        translate([-pl_x + pl_v, -pl_y, pl_z]) {
            rotate([0,0,90])
            translate([0,0,0]) cylinder(h = h, r1 = b, r2 = b, $fn=8);
        }
    }
}


//EOF/////////////////////////////////////////////////////


