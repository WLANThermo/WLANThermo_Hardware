// Gehäuse für das WLAN-Thermometer "Mini"
//
// WTM_MaloriakV37.scad (OpenSCAD >= 2015.11.13)
//
// Version 3.7 - 9.2.2016
//
// von Maloriak@Grillsportverein bzw. maloriak@gmail.com
//
// Für ein anderes Projekt habe ich ohnehin ein Gehäuse gebraucht und ich 
// wollte OpenSCAD kennenlernen. Auf dieses Weise ist dann diese weitere 
// Gehäusevariante für das WLAN-Thermometer "Mini" entstanden, welche auch 
// gut für den FDM-Druck geeignet ist.
//
// Der Vorteil in der Verwendung von OpenSCAD ist die Parametrisierung der Gehäusedaten.
// Veränderung sind dann sehr einfach möglich.
// So dauert die Veränderung der Breite oder Höhe des Gehäuses, falls Veränderungen
// der Platine oder am Display nötig sind, nur Sekunden.
//
// Der Deckel und der Boden sind beide in dieser SCAD-Datei enthalten, sodass das einwandfreie
// Zusammenpassen der Teile anhand von Referenzpunkten sichergestellt ist.
//
// Ob der Boden oder der Deckel erzeugt wird und welche Anschlußlöcher erzeugt werden und
// ob der Anti-Warp-Support generiert wird, lässt sich mittels Parameter einstellen.
//
// Dateien habe ich alle, zum Teil mehrfach, in PLA mit den Einstellungen
// 0.2 Schichtdicke, 20% Füllgrad, 0,8mm Wandstärke, 0,4mm unten/oben
// gedruckt und getestet.
// Fotos siehe
// http://www.grillsportverein.de/forum/threads/wlan-thermometer-mini-gehaeuse-varianten.253520/

// Zur Erzeugung des Gehäuses wird der Gehäuserahmen (Grundfläche, Seitenflächen) erzeugt
// und davon alles abgezogen, was den Rahmen durchbricht, also alle "Löcher". 
// Anschließend werden in das Gehäuse alle inneren Teile eingebaut.
// Das wird deshalb gemacht, da dann während des Entwurfs der Rahmen entfernt werden kann und
// er den Blick auf die Einbauten nicht verhindert.
// Sollte der Abzug vom Rahmen auch Teile betreffen, die im Inneren liegen, muss dort 
// nochmal etwas abgezogen werden (betrifft in unserem Fall nur den Abzug für die Köpfe
// der Gehäuseschrauben.
// 
// Referenzflächen/Punkte sind am Ende dieser Datei enthalten. Zusätzlich können zum
// Vergleich die STL-Dateien von Sisi eingeblendet werden.
//
// History

// V2    - Modifikation zur Verbesserung des 3D-Drucks mit FDM-Druckern, speziell mit dem
//         Pollin-PLA-Drucker
//       - Anti-Warp-Eckchen für Boden und Deckel hinzugefügt, da die durch Cura erzeugten 
//         nicht ausreichen.
//       - Deckel flacher gemacht und neuer LCD-Ausschnitt. Testdruck.
// V3    - Neudesign mittels OpenSCAD bei Beibehaltung der excakten Innenmasse.
// V3.1  - geänderte Anti-Warp-Eckchen. Testdruck.
// V3.2  - Skalierung in Breite, Höhe, Tiefe ermöglicht. Breakout-Einbauten/-Öffnungen und
//         Gehäueschrauben werden berechnet gem. Gehäuserand, LCD und Sensotlöcher bleiben
//         zentriert. Testdruck mit 5mm höherem Deckel.
//         (Bei Änderungen auf verfügbare Gehäuse-/Platinenschraubenlänge prüfen!)
// V3.3  - Optimierte Ausschnitt der Breakout-Gehäuselöcher
// V3.4  - Beschriftung der Sensoranschlüsse hinzugefügt. Optional, da bisl experimentell!
//       - Grillsportverein-Logo mit Schweinchen und Feuer aus PNG als STL erzeugt und 
//         als Abzug vom Deckel getestet: zu filigran, aber evtl ist Schrift ohne Schweinchen
//         möglich. Testdruck.
// V3.5: - Tiefere und breitere Versenkungen für die Gehäuseschraubenköpfe. 
//         Damit funktionieren jetzt 4mm x 25mm Schrauben mit unterschiedlichen Köpfen. Testdruck.
// V3.6  - Mutterhülsen für die Gehäuseschrauben hinzugefügt, nach einer Idee aus dem
//         Mainthread: damit ist kein Kleben mehr nötig.
//       - Gehäuse je 1mm breiter, wirkt sich vor allem günstig auf das obere Ende des
//         Platinenstapels aus.
//       - wieder "echte" 3mm Platz für den Bodenmagnet
//       - Testdruck.
// V3.7  - Abdeckung Magnetloch nur noch gut 1mm, damit mehr Platz für Bauteilende der Platinen-
//         lötseite
//       - 2 Pins der USB-Breakout-Platine werden weglassen, da nutzlos. 
//       - nochmal je 2mm mehr, nach dem ich http://www.grillsportverein.de/forum/threads/wlan-thermometer-mini.250253/page-58#post-2609979 gesehen hab ;-)
//


// Erzeuge Boden oder Deckel (nur eines auf "1" setzen!)
erzeuge_boden  = 1;  // =1 Boden erzeugen, =0 kein Boden erzeugen
erzeuge_deckel = 0;  // =1 Deckel erzeugen, =0 kein Deckel erzeugen

// Erzeuge die Anschlußvarianten (beliebig kombinierbar)
anschluss_mittig        = 0; // =1 Loch, =0 kein Loch
anschluss_links_rechts  = 0; // =1 Loch, =0 kein Loch

// Erzeuge Anti-Warp-Support
// Der Anti-Warp-Support ist optimiert auf möglichst kleine Verbindungsstellen zum Druckstück
// (dadurch weniger Ausbessern nach dem Druck) und funktiniert besser als der z.B. durch
// Cura automatisch erzeugte. Er wurde getestet mit PLA. Es ist dann *kein* weiterer 
// Warp-Schutz/Adhäsionsschutz nötig!
warp          = 1;  // =1 Anti-Warp-Schutz, =0 kein Anti-Warp-Schutz

// Die Höhe, Tiefe und Breite von Deckel und Boden kann hiermit getrennt voneinander 
// vergrößert werden.
// Die Einbauteile und Gehäuselöcher werden hierbei automatisch angepasst.
delta_boden   = 0;  // zusätzliche Gehäusehöhe in mm
delta_deckel  = 0;  // zusätzliche Gehäusehöhe in mm
delta_breite  = 3;  // zusätzliche Gehäusebreite in mm
delta_tiefe   = 3;  // zusätzliche Gehäusetiefe in mm

// Test: Beschriftung der Sensoren
// Eine Beschriftung der Sensoren kann hiermit testweise eingeschaltet werden.
// Es werden als negative Vertiefungen in die äußere Gehäusewand eingelassen und können
// z.B. mit Acrylfarbe ausgegossen werden. Diese Art der Beschriftung reicht mir
// momentan qualitätativ noch nicht. Aber vielleicht bekommt die Malerei jemand besser hin.
// Für den Fall kann man es einschalten.
beschriftung  = 0;  // =1 Kanalbeschriftung, =0 keine Kanalbeschriftung

// Test: Logo auf Deckel
// Als weiteren Test habe ich das Hinzufügen eines Logos als negative Vertiefung in den
// Deckel ausprobiert. Verwendet wird eine STL-Datei, die zuvor aus einer PNG-Datei
// erstellt wurde. Auch das ist eher zum Experimentieren gedacht.
logo          = 0;  // Logo auf Deckel

/////////////////////////////////////////////////////////////////////////////////
//////////////////////// Ab braucht nichts verändert werden. ////////////////////
/////////////////////////////////////////////////////////////////////////////////

// Gehäusemasse
innenmass_boden_hoehe  = -17.5 - delta_boden;
innenmass_deckel_hoehe = 15   + delta_deckel;
innenmass_breite       = 49 + delta_breite;
innenmass_tiefe        = 49 + delta_tiefe;

// Entwurfsmodus
entwurfsmodus  = 0;
zeige_boden    = 0;
zeige_deckel   = 0;

// Qualität der Rundungen
quali = 120;
// Tiefe der Beschriftungen, sinnvolle Werte 0.5 bis 1
beschriftungs_tiefe    = 0.6;

/////////////////////////////////////////////////////////////////////////////////
// Deckel erzeugen
if (erzeuge_deckel) {
    difference() {
        // Deckel geht in positive Z-Richtung
        union() {
            // Entwurfsmodus: Sicherstellung Kompatiblität
            if (zeige_deckel) {
                color("blue")
                rotate([90,0,0])
                translate([0,0,0]) {
                    import("W_Thermo_Mini/Deckel_Anschluss_links_mittig_rechts.stl");
                }
            }
            if (entwurfsmodus == 0) {
                rotate([180,0,0]) translate([0,0, -innenmass_deckel_hoehe]) deckel_rahmen();
            }
        }
        if (entwurfsmodus == 0) deckel_abzug();
    }
    
   if (entwurfsmodus == 1) {
       deckel_abzug();
   }

    /////////////////////////////////////////////////////////
    // Gehäuselöcher
    gl_x = innenmass_breite - 10.5;
    gl_y = innenmass_tiefe - 10.5;
    gl_z = 3;
 
    // rechts oben
    translate([gl_x, gl_y, gl_z])
    gehaeuse_loch_deckel(w = 4*30);

    // links oben
    translate([-gl_x, gl_y, gl_z])
    gehaeuse_loch_deckel(w = -4*30);

    // rechts unten
    translate([gl_x, -gl_y, gl_z])
    gehaeuse_loch_deckel(w = 30);

    // links unten
    translate([-gl_x, -gl_y, gl_z])
    gehaeuse_loch_deckel(w = -30);

    /////////////////////////////////////////////////////////
    // Platinenbefestigung
    pl_x = 42.3;
    pl_y = 21.7;
    pl_z = innenmass_deckel_hoehe;
    pl_v = 6;  // Versatz der linken Seite

    // rechts oben
    translate([pl_x, pl_y, pl_z])
    platinen_loch_deckel();
    // links oben
    translate([-pl_x + pl_v, pl_y, pl_z])
    platinen_loch_deckel();
    // rechts unten
    translate([pl_x, -pl_y, pl_z])
    platinen_loch_deckel();
    // links unten
    translate([-pl_x + pl_v, -pl_y, pl_z])
    platinen_loch_deckel();

    if (warp == 1) {
        //color("red")
        rotate([90,0,0]) antiwarp_deckel();
    }
} // erzeuge_deckel

/////////////////////////////////////////////////////////////////////////////////
// Boden erzeugen
if (erzeuge_boden) {
    difference() {
        // Boden geht in negative Z-Richtung
        union() {
            // Entwurfsmodus: Sicherstellung Kompatiblität
            if (zeige_boden) {
                color("red")
                rotate([90,0,0])
                translate([0,0,0])
                import("W_Thermo_Mini/Halter_Innenleben.stl");
            }
            if (entwurfsmodus == 0) {
                translate([0,0, innenmass_boden_hoehe]) boden_rahmen();
            }
        }
        if (entwurfsmodus == 0) boden_abzug();
    }
    
   if (entwurfsmodus == 1) {
       boden_abzug();
   }

    /////////////////////////////////////////////////////////
    // Magnetloch
    translate([0, 0, innenmass_boden_hoehe])
    magnet_loch();

    /////////////////////////////////////////////////////////
    // Breakout USB
    translate([24 - innenmass_breite, innenmass_tiefe - 20.5, innenmass_boden_hoehe])
    breakout_usb_aufnahme();

    /////////////////////////////////////////////////////////
    // Breakout Stromanschluß
    translate([innenmass_breite - 43, innenmass_tiefe - 11.5, innenmass_boden_hoehe])
    breakout_strom_aufnahme();

    difference() {
        union() {
            /////////////////////////////////////////////////////////
            // Gehäuselöcher
            gl_x = innenmass_breite - 10.5;
            gl_y = innenmass_tiefe - 10.5;
            gl_z = innenmass_boden_hoehe + 3;
          
            // rechts oben
            translate([gl_x, gl_y, gl_z])
            gehaeuse_loch_boden();

            // links oben
            translate([-gl_x, gl_y, gl_z])
            gehaeuse_loch_boden();

            // rechts unten
            translate([gl_x, -gl_y, gl_z])
            gehaeuse_loch_boden();

            // links unten
            translate([-gl_x, -gl_y, gl_z])
            gehaeuse_loch_boden();
        }
        schrauben_koepfe_diff();
    }

    /////////////////////////////////////////////////////////
    // Platinenbefestigung
    pl_x = 42.3;
    pl_y = 21.7;
    pl_z = innenmass_boden_hoehe;
    pl_v = 6;  // Versatz der linken Seite

    // rechts oben
    translate([pl_x, pl_y, pl_z])
    platinen_loch_boden();
    // links oben
    translate([-pl_x + pl_v, pl_y, pl_z])
    platinen_loch_boden();
    // rechts unten
    translate([pl_x, -pl_y, pl_z])
    platinen_loch_boden();
    // links unten
    translate([-pl_x + pl_v, -pl_y, pl_z])
    platinen_loch_boden();
    
    if (warp == 1) {
        //color("red")
        rotate([90,0,0]) antiwarp_boden();
    }
} // erzeuge_boden


/////////////////////////////////////////////////////////////////////////////////
// Module

/////////////////////////////////////////////////////////
// Seitenfläche + Grundfläche des Bodens
module boden_rahmen() {
    ab = innenmass_breite + 1;
    at = innenmass_tiefe + 1;
    d = 1;
    b = -innenmass_boden_hoehe + d;
    f = 2;
  
  // rechts  
    translate([ab - 2*d + d    ,-at  +f*0.1,   -d]) cube([d - f*0.1, 2*at - 2*f*0.1, b]);
    translate([ab - 2*d + d + d - f*0.1,-at - d, -2*d]) cube([d + f*0.1, 2*at + 2*d, b - d]);

  // links
    translate([-d - ab + 2*d - d + f*0.1,    -at +f*0.1   ,  -d]) cube([d - f*0.1, 2*at - 2*f*0.1, b]);
    translate([-d - ab + 2*d - d - d,-at - d,-2*d]) cube([d + f*0.1, 2*at + 2*d, b - d]);

 // oben
    translate([-ab + f*0.1,at - 2*d + d,  -d]) cube([2*ab - 2*f*0.1, d - f*0.1, b]);
    translate([-ab,at - 2*d + d + d - f*0.1,-2*d]) cube([2*ab, d + f*0.1, b - d]);

 // unten 
    translate([-ab + f*0.1,-d -at + 2*d - d + f*0.1,      -d])  cube([2*ab - 2*f*0.1, d - f*0.1, b]);
    translate([-ab,-d -at + 2*d - d - d,-2*d])  cube([2*ab, d + f*0.1, b - d]);

    translate([0,0,-d]) cube([ab * 2,at * 2,2*d], center=true);
}

/////////////////////////////////////////////////////////
// Seitenfläche + Grundfläche des Deckels
module deckel_rahmen() {
    ab = innenmass_breite + 1;
    at = innenmass_tiefe + 1;
    d = 1;
    b = innenmass_deckel_hoehe + d;
  
  // rechts  
    translate([ab - 2*d + d    ,    -at,0]) cube([d,       2*at, b - d]);
    translate([ab - 2*d + d + d,-at - d,0]) cube([d, 2*at + 2*d, b + d]);

  // links
    translate([    -d -ab + 2*d - d,    -at, 0]) cube([d, 2*at      , b - d]);
    translate([-d -ab + 2*d - d - d,-at - d,  0]) cube([d, 2*at + 2*d, b + d]);

 // oben
    translate([-ab,    at - 2*d + d, 0]) cube([2*ab, d, b - d]);
    translate([-ab,at - 2*d + d + d, 0]) cube([2*ab, d, b + d]);

 // unten 
    translate([-ab,-d -at + 2*d - d    ,  0]) cube([2*ab, d, b - d]);
    translate([-ab,-d -at + 2*d - d - d,  0]) cube([2*ab, d, b + d]);

    translate([0,0,d]) cube([ab * 2,at * 2,2*d], center=true);
}


/////////////////////////////////////////////////////////
// Alles, was den Boden durchbricht, ist hier aufgeführt
module boden_abzug() {
    union() {
            /////////////////////////////////////////////////////////
            // Sensorlöcher
            translate([-22.5,-innenmass_tiefe - 0.5,-0.5 + (innenmass_boden_hoehe / 2)]) sensor_loch_diff();
            translate([7.5,-innenmass_tiefe - 0.5,-0.5 + (innenmass_boden_hoehe / 2)]) sensor_loch_diff();
            translate([22.5,-innenmass_tiefe - 0.5,-0.5 + (innenmass_boden_hoehe / 2)]) sensor_loch_diff();
            translate([-7.5,-innenmass_tiefe - 0.5,-0.5 + (innenmass_boden_hoehe / 2)]) sensor_loch_diff();

            if (beschriftung == 1) {
                    translate([-22.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-0.5 + (innenmass_boden_hoehe / 2)]) rotate([90,0,0]) schrift("5",8);
                    translate([-7.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-0.5 + (innenmass_boden_hoehe / 2)]) rotate([90,0,0]) schrift("6",8);
                    translate([7.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-0.5 + (innenmass_boden_hoehe / 2)]) rotate([90,0,0]) schrift("7",8);
                    translate([22.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-0.5 + (innenmass_boden_hoehe / 2)]) rotate([90,0,0]) schrift("8",8);
            }
            
            translate([0, 0, innenmass_boden_hoehe])
            magnet_loch_diff();
                
            schrauben_koepfe_diff();
            
            translate([36.5 - innenmass_breite,innenmass_tiefe + 1,(innenmass_boden_hoehe - 7.7) + 17.5]) breakout_usb_diff();
            translate([innenmass_breite - 36.5,innenmass_tiefe + 1,(innenmass_boden_hoehe - 10.3) + 17.5]) breakout_strom_diff();
      }
}

/////////////////////////////////////////////////////////
// Loch für die Köpfe der Gehäuseschrauben
module schrauben_koepfe_diff() {
        gl_x = innenmass_breite - 10.5;
        gl_y = innenmass_tiefe - 10.5;
        gl_z = innenmass_boden_hoehe + 3;
  
        // rechts oben
        translate([gl_x, gl_y, gl_z])
        gehaeuse_loch_boden_diff();

        // links oben
        translate([-gl_x, gl_y, gl_z])
        gehaeuse_loch_boden_diff();

        // rechts unten
        translate([gl_x, -gl_y, gl_z])
        gehaeuse_loch_boden_diff();

        // links unten
        translate([-gl_x, -gl_y, gl_z])
        gehaeuse_loch_boden_diff();
}

/////////////////////////////////////////////////////////
// Alles, was den Deckel durchbricht, ist hier aufgeführt
module deckel_abzug() {
    union() {
        // Sensorlöcher
        translate([-22.5,-innenmass_tiefe - 0.5,-1.7 + (innenmass_deckel_hoehe / 2)]) sensor_loch_diff();
        translate([7.5,-innenmass_tiefe - 0.5,-1.7 + (innenmass_deckel_hoehe / 2)]) sensor_loch_diff();
        translate([22.5,-innenmass_tiefe - 0.5,-1.7 + (innenmass_deckel_hoehe / 2)]) sensor_loch_diff();
        translate([-7.5,-innenmass_tiefe - 0.5,-1.7 + (innenmass_deckel_hoehe / 2)]) sensor_loch_diff();

        if (beschriftung == 1) {
            translate([-22.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-1.7 + (innenmass_deckel_hoehe / 2)]) rotate([90,0,0]) schrift("1",8);
            translate([-7.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-1.7 + (innenmass_deckel_hoehe / 2)]) rotate([90,0,0]) schrift("2",8);
            translate([7.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-1.7 + (innenmass_deckel_hoehe / 2)]) rotate([90,0,0]) schrift("3",8);
            translate([22.5 -7,-innenmass_tiefe - 2 + beschriftungs_tiefe,-1.7 + (innenmass_deckel_hoehe / 2)]) rotate([90,0,0]) schrift("4",8);
        }

        if (anschluss_mittig == 1) {
            translate([0,innenmass_tiefe + 1,-1.4 + (innenmass_deckel_hoehe / 2)]) 
            anschluss_diff();
        }

        if (anschluss_links_rechts == 1) {
            translate([-17,innenmass_tiefe + 1,-1.4 + (innenmass_deckel_hoehe / 2)]) 
            anschluss_diff();
            translate([17,innenmass_tiefe + 1,-1.4 + (innenmass_deckel_hoehe / 2)]) 
            anschluss_diff();
        }
       
        // LCD-Ausschnitt 
        rotate([90,0,0])
            translate([0,0,0]) lcd();

        if (logo == 1) {
            translate([0,-innenmass_tiefe + 11 + delta_tiefe/2,innenmass_deckel_hoehe - 0.8]) logo();
        }
    }
}

/////////////////////////////////////////////////////////
// LCD-Ausschnitt
module lcd() {
    if (1) {
        b = 58 / 2;
        h = 44 / 2;
        color("cyan")
        translate([0,innenmass_deckel_hoehe - 1,0]) {
            b = b + 5.6;
            h = h + 4.3;
            translate([0,2.5,0]) polyhedron( 
                points = [ [b,0,h], [b,0,-h], [-b,0,-h], [-b,0,h],
                [0,- 0.6 * b,0] ],
                faces = [ [0,1,4],[1,2,4],[2,3,4],[3,0,4],[1,0,3],[2,1,3] ]
            );
        }
    }
}

/////////////////////////////////////////////////////////
// Loch für den Stromanschluss
module breakout_strom_diff() {
    rotate([90,0,0]) {
        difference() {
            if (entwurfsmodus == 1) {
                translate([0,0,0]) cube([22,16,6], center = true);
            }
            union() {
                translate([0,0,-1.84]) cube([12,8,3.9], center = true);
                translate([2.8,0.25,-3.5]) cylinder(h=8, r1=1.5, r2=1.5, $fn=quali);
                translate([-2.8,0.25,-3.5]) cylinder(h=8, r1=1.5, r2=1.5, $fn=quali);
                translate([2.5,-0.9,-3.5]) cylinder(h=8, r1=1.2, r2=1.2, $fn=quali);
                translate([-2.5,-0.9,-3.5]) cylinder(h=8, r1=1.2, r2=1.2, $fn=quali);
                translate([0,-0.6,0]) cube([4.9,3,8], center = true);
                translate([0,0.25,0]) cube([5.4,3,8], center = true);
            }
         }
    }
}

/////////////////////////////////////////////////////////
// Loch für den USB-Anschluss
module breakout_usb_diff() {
    rotate([90,0,0]) {
        difference() {
            if (entwurfsmodus == 1) {
                translate([0,0,0]) cube([22,16,6], center = true);
            }
            translate([0,0,0]) cube([14.8,7.5,8], center = true);
        }
    }
}


/////////////////////////////////////////////////////////
// Loch für einen Sensoranschluss
module sensor_loch_diff() {
    rotate([90,0,0]) {
        difference() {
            if (entwurfsmodus == 1) {
                translate([0,0,0]) cube([15,15,6], center = true);
            }
            union() {
            translate([0,0,-4]) cylinder(h = 8, r1 = 3, r2 = 3, $fn=quali);
            translate([0,0,0.75]) cylinder(h = 4, r1 = 4.2, r2 = 4.2, $fn=quali);
            }
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
            translate([0,0,-4]) cylinder(h = 4, r1 = 7, r2 = 6.5, $fn=6);
            }
        }
    
    }
}

/////////////////////////////////////////////////////////
// Magnetlochbereich
module magnet_loch() {
    r = 12;
    bd = 2;
    difference() {
        translate([0,0, -bd]) cylinder(h = 2 + bd, r1 = r + 6, r2 = r, $fn=quali);
        translate([0,0, -bd - 0.1]) cylinder(h = bd + 0.1 + 1, r1 = r - 1.3, r2 = r - 1.6, $fn=quali);
        
    }
}

/////////////////////////////////////////////////////////
// Magnetlochbereich (Abzug)
module magnet_loch_diff() {
    r = 12;
    bd = 2; // war: 2
    difference() {
       if (entwurfsmodus == 1) {
          translate([0,0, -bd + 2.5]) cube([25,25,5], center=true);
       }
       translate([0,0, -bd - 0.1]) cylinder(h = bd + 0.1, r1 = r - 1.3, r2 = r - 1.6, $fn=quali);
        
    }
}

/////////////////////////////////////////////////////////
// Sockel für die Stromanschluß-Breakout-Platine
module breakout_strom_aufnahme() {
    breakout_strom_aufnahme_links();
    translate([13,0,0]) mirror([1,0,0]) breakout_strom_aufnahme_links();
}

module breakout_strom_aufnahme_links() {
    cube([4,11,4]);
    translate([4,0,0]) cube([2.5,2,4]);
    translate([4,9,0]) cube([2.5,2,4]);
    pin_x = 2.2;
    pin_y = 4;
    translate([pin_x, pin_y,0]) cylinder(h = 6, r1 = 1.47, r2 = 1.47, $fn=quali);
    translate([pin_x, pin_y,6]) cylinder(h = 1, r1 = 1.47, r2 = 0.8, $fn=quali);
}


/////////////////////////////////////////////////////////
// Sockel für die USB-Anschluss-Breakout-Platine
module breakout_usb_aufnahme() {
    breakout_usb_aufnahme_links();
    translate([25,0,0]) mirror([1,0,0]) breakout_usb_aufnahme_links();
}

module breakout_usb_aufnahme_links() {
    cube([6.5,10,4]);
    translate([0,10,0]) cube([3.5,5,4]);
    translate([0,15,0]) cube([6.5,5,4]);
    pin_x = 2.38;
    pin_y = 2.24;
    translate([pin_x, pin_y,0]) cylinder(h = 6, r1 = 1.47, r2 = 1.47, $fn=quali);
    translate([pin_x, pin_y,6]) cylinder(h = 1, r1 = 1.47, r2 = 0.8, $fn=quali);
    // die nächsten zwei Pins sind entbehrlich und funktionieren sowieso mit der 
    // Breakout-Platine gem. Beschreibung nicht. Gem. Armin hält die Platine auch so.
    //translate([pin_x, pin_y + 15.3,0]) cylinder(h = 6, r1 = 1.47, r2 = 1.47, $fn=quali);
    //translate([pin_x, pin_y + 15.3,6]) cylinder(h = 1, r1 = 1.47, r2 = 0.8, $fn=quali);

}


/////////////////////////////////////////////////////////
// Hülse für den Schraubenkopf des Platinenteils (Boden)
// Der ursprüngliche Entwurf sieht hier Sechskantkopfschrauben vor.
// Habe es aber auch mit Senkkopfschrauben getestet. Einige Rundkopfschrauben 
// scheinen *nicht* zu passen, aber der lokale Baumarkt hilft.
module platinen_loch_boden() {
    h = 4;
    a = 5;
    b = 3.262;
    
    difference() {
        cylinder(h = h, r1 = a, r2 = a, $fn=quali);
        translate([0,0, 0.5]) cylinder(h = h + 3, r1 = b, r2 = b, $fn=6);
    }
}

/////////////////////////////////////////////////////////
// Hülse für die Schraube des Platinenteils (Boden)
module platinen_loch_deckel() {
    h = 6.4;
    a = 3.5;
    b = 2.1;
    
    rotate([0,0,90])
    difference() {
        translate([0,0,-h]) cylinder(h = h, r1 = a, r2 = a, $fn=quali);
        translate([0,0,-h - 0.1]) cylinder(h = h - 4, r1 = b, r2 = b, $fn=8);
    }
}

/////////////////////////////////////////////////////////
// Loch für die Gehäuseschraube
module gehaeuse_loch_boden() {
    h = -innenmass_boden_hoehe;
    a = 6.5;
    b = 2.5;
    
    rotate(90)
    difference() {
        translate([0,0, -3]) cylinder(h = h, r1 = a, r2 = a, $fn=quali);
        translate([0,0,-3.1]) cylinder(h = h + 0.2, r1 = b, r2 = b, $fn=quali);
    }
}

/////////////////////////////////////////////////////////
// Loch für den Kopf der Gehäuseschraube
module gehaeuse_loch_boden_diff() {
    bd = 3;
    h = bd + 9;
    b = 4.2;

    rotate(90)
    difference() {
        if (entwurfsmodus == 1) {
          translate([0,0,-2.5]) cube([15,15,bd + 4], center=true);
        }
        translate([0,0,-9 - bd]) cylinder(h = h + 0.2, r1 = b, r2 = b, $fn=quali);
    }
}

/////////////////////////////////////////////////////////
// Loch für eine Schraubenmutter
// bleibt gleich tief, auch bei Änderung Gehäusehöhe
module gehaeuse_loch_deckel_old() {
    h = innenmass_deckel_hoehe;
    a = 6.5;
    b = 4.3;
    c = 3;
    
    difference() {
        translate([0,0, - 3]) cylinder(h = h, r1 = a, r2 = a, $fn=quali);
        union() {
            translate([0,0,-3.1]) cylinder(h = 15 - 9.9, r1 = b, r2 = b, $fn=6);
            translate([0,0,-3.1]) cylinder(h = 15 - 4.5, r1 = c, r2 = c, $fn=6);
        }
    }
}


module gehaeuse_loch_deckel_diff(w = 30, d_a = 7.2, d_h = 4) {
    b = d_h;
    c = 3;
    d = 4;
    union() {
        translate([0,0,d]) cylinder(h = d_h, r1 = b, r2 = b, $fn=6);
        translate([0,0,0]) cylinder(h = 10, r1 = c, r2 = c, $fn=6);
        rotate([0,0,w])
        translate([-d_a/2,-2,d])
        color("red")
        cube([d_a,15,d_h]);
    }
}

/////////////////////////////////////////////////////////
// Seitliches Loch für eine Schraubenmutter
// bleibt gleich tief, auch bei Änderung Gehäusehöhe
module gehaeuse_loch_deckel(w = 30, d_a = 7.2, d_h= 4) {
    h = innenmass_deckel_hoehe;
    a = 6.5;
    
    difference() {
        translate([0,0, -3]) cylinder(h = h, r1 = a, r2 = a, $fn=quali);
        translate([0,0,-3.1]) gehaeuse_loch_deckel_diff(w, d_a, d_h);
    }
}

/////////////////////////////////////////////////////////
// Abzug für ein Logo auf dem Gehäusedeckel
module logo() {
    b = 31;
    h = 12;
    difference() {
        translate([-b,-h,0.1]) cube([b*2,h*2,2]);
        scale([0.16,0.16,2])
        color("green")
        import("logo.stl");
    }
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
   q  = innenmass_boden_hoehe - 2;
   p = 12;
   ab = innenmass_breite + 1;
   at = innenmass_tiefe + 1;
   b = 5;
  
   translate([ab, q, at - p - b]) cube([p + b, d, p + 3*b]);
   translate([ab + 2*b, q, -b]) cube([p - b, d, (innenmass_breite + innenmass_tiefe)/2 + b]);
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
   q  = innenmass_deckel_hoehe - d;
   p = 12;
   ab = innenmass_breite + 1;
   at = innenmass_tiefe + 1;
   b = 5;
  
   translate([ab, q, at - p - b]) cube([p + b, d, p + 3*b]);
   translate([ab + 2*b, q, -b]) cube([p - b, d, (innenmass_breite + innenmass_tiefe)/2 + b]);
}

/////////////////////////////////////////////////////////
// Schrift (Abzug)
module schrift(letter, size=10) {
   linear_extrude(height=size, convexity=4)
   text(letter, 
       size=size*22/30,
       font="Arial",
       halign="center",
       valign="center");
 }

/////////////////////////////////////////////////////////////////////////////////
// Referenzen
 
// Referenz: Einbauten Boden
if (0) {
    color("green")
    translate([-60,-60,innenmass_boden_hoehe])
    cube([120,120,1]);
}

// Referenz: Einbauten Deckel
if (0) {
    color("green")
    translate([-60,-60,innenmass_deckel_hoehe - 1])
    cube([120,120,1]);
}

// Referenz: Gehäusebreite
if (0) {
    h = -innenmass_boden_hoehe + innenmass_deckel_hoehe;
    color("green")
    translate([innenmass_breite,-innenmass_tiefe,innenmass_boden_hoehe])
    cube([1,innenmass_tiefe * 2, h]);
}

// Referenz: Gehäusetiefe
if (0) {
    h = -innenmass_boden_hoehe + innenmass_deckel_hoehe;
    color("green")
    translate([-innenmass_breite,innenmass_tiefe,innenmass_boden_hoehe])
    cube([innenmass_breite * 2,1,h]);
}

// Test Lochmasse Gehäuseschrauben
if (0) {
    translate([0,5,0]) gehaeuse_loch_deckel(d_a = 7.2, d_h= 4.2);
    translate([15,0,0]) gehaeuse_loch_deckel(d_a = 7.1, d_h= 4.1);
    translate([30,0,0]) gehaeuse_loch_deckel(d_a = 7, d_h= 4.1);
    translate([45,0,0]) gehaeuse_loch_deckel(d_a = 7.2, d_h= 4);
}


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



