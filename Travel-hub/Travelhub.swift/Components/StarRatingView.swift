import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var maxRating: Int = 5
    var size: CGFloat = 28
    var interactive: Bool = true
    var filledColor: Color = .yellow
    var emptyColor: Color = Color(.systemGray4)

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(star <= rating ? filledColor : emptyColor)
                    .onTapGesture {
                        if interactive {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                rating = star
                            }
                        }
                    }
            }
        }
    }
}

struct StaticStarRatingView: View {
    let rating: Double
    var maxRating: Int = 5
    var size: CGFloat = 14
    var filledColor: Color = .yellow

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: Double(star) <= rating ? "star.fill" :
                      (Double(star) - 0.5 <= rating ? "star.leadinghalf.filled" : "star"))
                    .font(.system(size: size))
                    .foregroundColor(Double(star) <= rating + 0.5 ? filledColor : Color(.systemGray4))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: .constant(3))
        StaticStarRatingView(rating: 3.5)
        StaticStarRatingView(rating: 4.5, size: 20)
    }
}
