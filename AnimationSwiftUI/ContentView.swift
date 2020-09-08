//
//  ContentView.swift
//  AnimationSwiftUI
//
//  Created by Mihir Vyas on 02/09/20.
//  Copyright © 2020 Mihir vyas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    NavigationLink(destination: Example4(), label: {
                        Text("SwiftUI-Animation")
                    })
                }
            }.navigationBarTitle("Animation").listRowBackground(Color.red)
        }
    }
}

struct MyButton: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
                .font(font)
                .padding(10)
                .frame(width: 70)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green).shadow(radius: 2))
                .foregroundColor(textColor)
            
        })
    }
}

struct Example4: View {
    @State private var sides: Double = 4
    @State private var scale: Double = 1.0
    
    
    var body: some View {
        VStack {
            Example4PolygonShape(sides: sides, scale: scale)
                .stroke(Color.pink, lineWidth: (sides < 3) ? 10 : ( sides < 7 ? 5 : 2))
                .padding(20)
                .animation(.easeInOut(duration: 3.0))
                .layoutPriority(1)
            
            
            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")
            
            Slider(value: $sides, in: 0...30)
            
            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.sides = 1.0
                    self.scale = 1.0
                }
                
                MyButton(label: "3") {
                    self.sides = 3.0
                    self.scale = 1.0
                }
                
                MyButton(label: "7") {
                    self.sides = 7.0
                    self.scale = 1.0
                }
                
                MyButton(label: "30") {
                    self.sides = 30.0
                    self.scale = 1.0
                }
                
            }
        }.navigationBarTitle("Programming-Proton").padding(.bottom, 50)
    }
}


struct Example4PolygonShape: Shape {
    var sides: Double
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sides) + extra {
            
            let angle = (Double(i) * (360.0 / sides)) * (Double.pi / 180)
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            vertex.append(pt)
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        // Draw vertex-to-vertex lines
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        
        return path
    }
    
    func drawVertexLines(path: inout Path, vertex: [CGPoint], n: Int) {
        
        if (vertex.count - n) < 3 { return }
        
        for i in (n+2)..<min(n + (vertex.count-1), vertex.count) {
            path.move(to: vertex[n])
            path.addLine(to: vertex[i])
        }
        
        drawVertexLines(path: &path, vertex: vertex, n: n+1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
