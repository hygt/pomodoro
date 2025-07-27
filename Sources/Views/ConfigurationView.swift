import SwiftUI

struct ConfigurationView: View {
    @Binding var focusTime: TimeInterval
    @Binding var breakTime: TimeInterval
    let onStart: () -> Void
    
    private var focusMinutes: Int {
        get { Int(focusTime / 60) }
        set { focusTime = TimeInterval(newValue * 60) }
    }
    
    private var breakMinutes: Int {
        get { Int(breakTime / 60) }
        set { breakTime = TimeInterval(newValue * 60) }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 15) {
                Text("🍅 Pomodoro Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text("Configure your productivity sessions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 40) {
                // Focus Time Picker
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Focus Time")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                if focusMinutes > 1 {
                                    focusTime -= 60
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            VStack {
                                Text("\(focusMinutes)")
                                    .font(.system(size: 72, weight: .light, design: .default))
                                    .foregroundColor(.primary)
                                    .monospacedDigit()
                                
                                Text("minutes")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if focusMinutes < 120 {
                                    focusTime += 60
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 140)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
                
                // Break Time Picker
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text("Break Time")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                if breakMinutes > 1 {
                                    breakTime -= 60
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            VStack {
                                Text("\(breakMinutes)")
                                    .font(.system(size: 72, weight: .light, design: .default))
                                    .foregroundColor(.primary)
                                    .monospacedDigit()
                                
                                Text("minutes")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if breakMinutes < 60 {
                                    breakTime += 60
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 140)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
            }
            
            Button(action: onStart) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Session")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(
                    gradient: Gradient(colors: [.orange, .red]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(40)
        .frame(minWidth: 500, minHeight: 700)
        .background(Color(.controlBackgroundColor))
    }
}
