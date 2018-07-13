//
//  Observable+Ext.swift
//  SwiftMVVM
//
//  Created by Vitor Otero Machado on 10/07/2018.
//  Copyright © 2018 TeCApp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {
    typealias DomainType = Element.Iterator.Element.DomainType
    
    func mapToDomain() -> Observable<[DomainType]> {
        return map { $0.mapToDomain() }
    }
}

extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias Element = Iterator.Element
    
    func mapToDomain() -> [Element.DomainType] {
        return map { $0.asDomain() }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    func skipNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
    
    func whenNil(returns wrappedValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ??
                Observable<Element.Wrapped>.just(wrappedValue)
        }
    }
}

extension SharedSequenceConvertibleType where E: OptionalType {
    func skipNil() -> Driver<E.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<E.Wrapped>.just($0) } ?? Driver<E.Wrapped>.empty()
        }
    }
    
    func whenNil(returns wrappedValue: E.Wrapped) -> Driver<E.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<E.Wrapped>.just($0) } ?? Driver<E.Wrapped>.just(wrappedValue)
        }
    }
}
