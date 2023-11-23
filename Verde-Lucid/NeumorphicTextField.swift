import SwiftUI

struct NeumorphicTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme

    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(neumorphicBackgroundColor())
                    .softOuterShadow(darkShadow: neumorphicDarkShadow(), lightShadow: neumorphicLightShadow(), offset: 5, radius: 10)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 12), darkShadow: neumorphicDarkShadow(), lightShadow: neumorphicLightShadow(), spread: 0.1, radius: 2)
            )
    }

    func neumorphicBackgroundColor() -> Color {
        return colorScheme == .dark ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 236/255, green: 240/255, blue: 243/255)
    }

    func neumorphicDarkShadow() -> Color {
        return colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.1) : Color.Neumorphic.darkShadow
    }

    func neumorphicLightShadow() -> Color {
        return colorScheme == .dark ? Color(red: 35/255, green: 36/255, blue: 37/255) : Color.Neumorphic.lightShadow
    }
}
