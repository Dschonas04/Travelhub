import SwiftUI

struct PhotoSharingView: View {
    let trip: Trip

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 64))
                .foregroundColor(.gray.opacity(0.5))
            Text("Fotos teilen")
                .font(.title2)
                .fontWeight(.bold)
            Text("Teile deine besten Reisefotos mit der Gruppe")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button(action: {}) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Foto hinzufuegen")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appPrimary)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .background(Color.appBackground)
        .navigationTitle("Fotos teilen")
        .navigationBarTitleDisplayMode(.inline)
    }
}
