//
//  Years.swift
//  JalanPlus
//
//  Created by Apple on 19/3/25.
//
import Foundation
import SwiftUI

struct YearBox: Identifiable, Hashable {
    let id = UUID()
    let title : String
    let imageName : String
    let subtext : String
}

var years : [YearBox] = [
    YearBox(title: "1960",imageName: "1960s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "1970",imageName: "1970s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "1980",imageName: "1980s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "1990",imageName: "1990s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "2000",imageName: "2000s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "2010",imageName: "2010s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    YearBox(title: "2020",imageName: "2020s", subtext: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquet gravida massa, et ultrices sapien. Praesent eget est sed est finibus dictum a in est. Aliquam erat volutpat. Aliquam purus nulla, scelerisque in bibendum sit amet, egestas eu tellus. Aenean pellentesque porttitor iaculis. Nullam pellentesque luctus nibh. Ut sit amet diam dui. Vivamus dignissim, elit vitae interdum porttitor, nisl nunc vestibulum urna, ut lacinia enim ex sit amet nunc. Donec convallis rhoncus lobortis. Mauris lobortis rutrum ante at iaculis. In sed suscipit justo, eget suscipit ex. Donec venenatis elit vel erat elementum, faucibus posuere sem facilisis. Praesent non rhoncus orci, in ullamcorper lacus."),
    
]


