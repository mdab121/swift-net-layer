//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 20.01.2020.
//

import Foundation

public protocol SNLFilePrtcl {

    var data: Data { get set }
    var fileName: String { get set }
}
