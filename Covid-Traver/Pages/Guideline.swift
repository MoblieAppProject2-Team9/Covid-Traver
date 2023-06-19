import SwiftUI

struct Guideline: View {
    @State private var selectedCountry: cntry?
    @State private var selectedOoption = 0
    var body: some View {
        VStack {
            //padding()
            Button(action: {
                selectedCountry = nil
            }) {
                Text("나라 선택 해제")
            }
            Text("나라를 선택해 주세요")
                .foregroundColor(.black)
                .font(.system(size:25).bold())
                
                List(countryList, id: \.name) { country in
                    Button(action: {
                        selectedCountry = country
                    }) {
                        Text(country.name)
                    }
                }
//            header: {
//                Text("Country?").font(.largeTitle)
//            }.listStyle(.sidebar)
            
            
            Spacer()
            
            if let selectedCountry = selectedCountry {
                ScrollView {
                    VStack {
                        Text(selectedCountry.name)
                            .font(.title)
                            .padding()
                        
                        Text(selectedCountry.info)
                            .font(.body)
                            .padding()
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
    

}

struct Guideline_Previews: PreviewProvider {
    static var previews: some View {
        Guideline()
    }
}
