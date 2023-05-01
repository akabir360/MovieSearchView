//
//  ContentView.swift
//  MovieSearchView
//
//  Created by Abu Sayeed Kabir on 1/5/2023.
//

import SwiftUI

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
}

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
    let runtime: Int?
}

class APIClient {
    static let apiKey = "api_key"
    static let baseURL = "https://api.themoviedb.org/3"
    
    static func searchMovies(query: String, completion: @escaping ([Movie]) -> ()) {
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func getMovieDetails(id: Int, completion: @escaping (MovieDetail) -> ()) {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(movieDetail)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ContentView: View {
    @State private var searchQuery: String = ""
    @State private var movies: [Movie] = []
    @State private var selectedMovie: Movie?
    @State private var movieDetail: MovieDetail?
    @State private var showingMovieDetail: Bool = false
    
    var body: some View {
        VStack {
            TextField("Search for a movie", text: $searchQuery, onCommit: {
                APIClient.searchMovies(query: searchQuery) { movies in
                    self.movies = movies
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .disableAutocorrection(true)
            
            List(movies, id: \.id) { movie in
                Button(action: {
                    self.selectedMovie = movie
                    APIClient.getMovieDetails(id: movie.id) { movieDetail in
                        self.movieDetail = movieDetail
                        self.showingMovieDetail = true
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .sheet(isPresented: $showingMovieDetail) {
            if let movieDetail = self.movieDetail {
                MovieDetailView(movieDetail: movieDetail)
            }
        }
    }
}
struct MovieDetailView: View {
    let movieDetail: MovieDetail
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if let posterPath = movieDetail.poster_path {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
            VStack(alignment: .leading) {
                Text(movieDetail.title)
                    .font(.title)
                    .padding(.top)
                Text(movieDetail.overview)
                    .font(.body)
                    .padding(.top)
                Text("Released on: \(movieDetail.release_date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
                Text("Runtime: \(movieDetail.runtime ?? 0) minutes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
                Text("Average Rating: \(String(format: "%.1f", movieDetail.vote_average)) / 10")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        )
    }
}



