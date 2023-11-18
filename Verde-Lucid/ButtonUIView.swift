//import SwiftUI
//
//struct CorrectButton: View {
//    @State var tap = false
//    @State var press = false
//    @State var alterState = false
//    
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(lineWidth: alterState ? 20 : 0)
//                .frame(width: alterState ? 500 : 0, height: alterState ? 500 : 0)
//                .foregroundColor(Color(#colorLiteral(red: 0.49200207, green: 1, blue: 0.4950069785, alpha: 1)))
//                .blur(radius: alterState ? 5 : 20)
//                .opacity(alterState ? 0 : 1)
//            
//            Text("Add to cart")
//                .font(.system(size: 20, weight: .semibold, design: .rounded))
//                .foregroundColor(alterState ? Color.clear : (tap ? 
//                                                             Color(#colorLiteral(red: 0.4931054115, green: 0.6306983232, blue: 1, alpha: 1)):
//                                                             Color(#colorLiteral(red: 0.4657435417, green: 0.5916289687, blue: 0.9575648904, alpha: 0.8119689388))))
//                .frame(width: 200, height: alterState ? 200 : 60)
//                .background(
//                    ZStack {
//                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
//                        
//                        RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous)
//                            .foregroundColor(.white)
//                            .blur(radius: 3)
//                            .offset(x: -2, y: -2)
//                        
//                        RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous)
//                            .fill(
//                                alterState ?
//                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7411747575, green: 0.9638548493, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.49200207, green: 1, blue: 0.4950069785, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing) :
//                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194613099, green: 0.941408515, blue: 1, alpha: 0.75)), Color.white]), startPoint: tap ? .top : .topTrailing, endPoint: tap ? .bottom : .bottomLeading)
//                            )
//                            .padding(2)
//                            .blur(radius: 3)
//                            .offset(x: 3, y: 3)
//                    }
//                )
//                .clipShape(RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous))
//                .shadow(color: press ? Color(#colorLiteral(red: 0.4931054115, green: 0.6306983232, blue: 1, alpha: 1)) : Color.clear, radius: 9, x: 0, y: 0)
//                .shadow(color: press ? Color.clear : (tap ? Color(#colorLiteral(red: 0.4132584929, green: 0.4436882138, blue: 0.5055162311, alpha: 0.7532925793)) : Color(#colorLiteral(red: 0.6476906538, green: 0.6953927875, blue: 0.7922747135, alpha: 0.5097243202))), radius: tap ? 5:10, x: tap ? 1:20, y: tap ? 1:20)
//                .scaleEffect(alterState ? 0 : (tap ? 0.9 : 1))
//                .gesture(
//                    DragGesture(minimumDistance: 0)
//                        .onChanged { _ in
//                            if self.press == true {
//                                self.press = false
//                            }
//                            self.tap = true
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                if self.tap == true {
//                                    self.press = true
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//                                        self.alterState = true
//                                    }
//                                }
//                            }
//                        }
//                        .onEnded{ _ in
//                            if self.press == false {
//                                self.tap = false
//                            }
//                        }
//                )
//                .opacity(alterState ? 0 : 0.9)
//                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
//                .statusBar(hidden: true)
//        }
//    }
//}
//
//struct CorrectButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CorrectButton()
//    }
//}



















import SwiftUI

struct ColorVariablesLight {
    static let primaryColor = Color(.black)
    static let secondaryColor = Color(#colorLiteral(red: 0.4657435417, green: 0.5916289687, blue: 0.9575648904, alpha: 0.8119689388))
    static let backgroundColor = Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
    static let shadowColor = Color(#colorLiteral(red: 0.4931054115, green: 0.6306983232, blue: 1, alpha: 1))
    static let pressShadowColor = Color(#colorLiteral(red: 0.6476906538, green: 0.6953927875, blue: 0.7922747135, alpha: 0.5097243202))
    static let tapShadowColor = Color(#colorLiteral(red: 0.4132584929, green: 0.4436882138, blue: 0.5055162311, alpha: 0.7532925793))
}

struct ColorVariablesDark {
    static let primaryColor = Color(.white) // Accent color (dark blue)
    static let secondaryColor = Color(.white) // Highlight color
    static let backgroundColor = Color(red: 48/255, green: 49/255, blue: 53/255) // Background color
    static let shadowColor = Color(red: 22/255, green: 22/255, blue: 22/255)
    static let pressShadowColor = Color(red: 60/255, green: 61/255, blue: 65/255)
    static let tapShadowColor = Color(#colorLiteral(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)) // Different color for tap shadow (green for example)
}


struct CorrectButton: View {
    @State var tap = false
    @State var press = false
    @State var alterState = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let ColorVariables: (
            primaryColor: Color,
            secondaryColor: Color,
            backgroundColor: Color,
            shadowColor: Color,
            pressShadowColor: Color,
            tapShadowColor: Color
        ) = colorScheme == .dark ?
            (
                ColorVariablesDark.primaryColor,
                ColorVariablesDark.secondaryColor,
                ColorVariablesDark.backgroundColor,
                ColorVariablesDark.shadowColor,
                ColorVariablesDark.pressShadowColor,
                ColorVariablesDark.tapShadowColor
            ) :
            (
                ColorVariablesLight.primaryColor,
                ColorVariablesLight.secondaryColor,
                ColorVariablesLight.backgroundColor,
                ColorVariablesLight.shadowColor,
                ColorVariablesLight.pressShadowColor,
                ColorVariablesLight.tapShadowColor
            )
                
        ZStack {
            Circle()
                .stroke(lineWidth: alterState ? 20 : 0)
                .frame(width: alterState ? 500 : 0, height: alterState ? 500 : 0)
                .foregroundColor(ColorVariables.primaryColor)
                .blur(radius: alterState ? 5 : 20)
                .opacity(alterState ? 0 : 1)
            
            Text("Add to cart")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(alterState ? Color.clear : (tap ?
                                                             ColorVariables.secondaryColor :
                                                             ColorVariables.primaryColor))
                .frame(width: 200, height: alterState ? 200 : 60)
                .background(
                    ZStack {
                        ColorVariables.backgroundColor
                        
                        RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous)
                            .foregroundColor(.white)
                            .blur(radius: 3)
                            .offset(x: -2, y: -2)
                        
                        RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous)
                            .fill(
                                alterState ?
                                    LinearGradient(gradient: Gradient(colors: [ColorVariables.primaryColor, ColorVariables.secondaryColor]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                                    LinearGradient(gradient: Gradient(colors: [ColorVariables.backgroundColor, Color.white]), startPoint: tap ? .top : .topTrailing, endPoint: tap ? .bottom : .bottomLeading)
                            )
                            .padding(2)
                            .blur(radius: 3)
                            .offset(x: 3, y: 3)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: alterState ? 100 : 16, style: .continuous))
                // Rest of the view code remains the same
//                .shadow(color: press ? colorVariables.shadowColor : Color.clear, radius: 9, x: 0, y: 0)
//                            .shadow(color: press ? Color.clear : (tap ? colorVariables.tapShadowColor : colorVariables.pressShadowColor), radius: tap ? 5:10, x: tap ? 1:20, y: tap ? 1:20)
                            
                .shadow(color: press ? ColorVariables.shadowColor : Color.clear, radius: 9, x: 0, y: 0)
                            .shadow(color: press ? Color.clear : (tap ? ColorVariables.tapShadowColor : ColorVariables.pressShadowColor), radius: tap ? 5:10, x: tap ? 1:20, y: tap ? 1:20)
                .scaleEffect(alterState ? 0 : (tap ? 0.9 : 1))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if self.press == true {
                                self.press = false
                            }
                            self.tap = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if self.tap == true {
                                    self.press = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        self.alterState = true
                                    }
                                }
                            }
                        }
                        .onEnded{ _ in
                            if self.press == false {
                                self.tap = false
                            }
                        }
                )
                .opacity(alterState ? 0 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                .statusBar(hidden: true)
        }
    }
}

struct CorrectButton_Previews: PreviewProvider {
    static var previews: some View {
        CorrectButton()
    }
}
